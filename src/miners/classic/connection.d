// Copyright © 2011, Jakob Bornecrantz.  All rights reserved.
// See copyright notice in src/charge/charge.d (GPLv2 only).
module miners.classic.connection;

import std.socket;
import std.string;
private static import etc.c.zlib;
private import std.zlib : ZlibException;

import charge.charge;

import miners.types;
import miners.classic.proto;
import miners.importer.network;

alias charge.net.util.ntoh ntoh;


/**
 * Receiver of client packages.
 */
interface ClientListener
{
	void indentification(ubyte ver, char[] name, char[] motd, ubyte type);

	void levelInitialize();
	void levelLoadUpdate(ubyte precent);
	void levelFinalize(uint x, uint y, uint z, ubyte data[]);

	void setBlock(short x, short y, short z, ubyte type);

	void playerSpawn(byte id, char[] name, double x, double y, double z,
			 ubyte yaw, ubyte pitch);

	void playerMoveTo(byte id, double x, double y, double z,
			  ubyte yaw, ubyte pitch);
	void playerMove(byte id, double x, double y, double z,
			ubyte yaw, ubyte pitch);
	void playerMove(byte id, double x, double y, double z);
	void playerMove(byte id, ubyte yaw, ubyte pitch);
	void playerDespawn(byte id);
	void playerType(ubyte type);

	void ping();
	void message(byte id, char[] message);
	void disconnect(char[] reason);
}

/**
 * A threaded TCP connection to a server that handles protocol parsing. 
 */
class ClientConnection : public NetThreadedPacketQueue
{
private:
	// Server details
	char[] hostname;
	ushort port;

	/// Username that was authenticated to mc.net
	char[] username;

	/// Verification recieved from mc.net
	char[] verificationKey;

	/// Stored data when receiving the level
	ubyte[] inData;

	/// Receiver of packages
	ClientListener l;

public:
	this(ClientListener l, ClassicServerInfo csi)
	{
		this.l = l;

		this.hostname = csi.hostname;
		this.port = csi.port;

		this.username = csi.username;
		this.verificationKey = csi.verificationKey;

		super();
	}

	~this()
	{
		freePacketsUnsafe();
	}

	void setListener(ClientListener l)
	{
		this.l = l;
	}

	/**
	 * Push all the packages to the listener.
	 */
	void doPackets()
	{
		popPackets(&packet);
	}


	/*
	 *
	 * Client send functions.
	 *
	 */


	void sendClientIdentification(char[] name, char[] key)
	{
		ClientIdentification ci;

		ci.packetId = ci.constId;
		ci.protocolVersion = 0x07;
		ci.username[0 .. name.length] = name[0 .. $];
		ci.username[name.length .. $] = ' ';
		ci.verificationKey[0 .. key.length] = key[0 .. $];
		ci.verificationKey[key.length .. $] = ' ';
		ci.pad = 0;

		sendPacket!(ci)(s);
	}

	void sendClientSetBlock(short x, short y, short z, ubyte mode, ubyte type)
	{
		ClientSetBlock csb;

		csb.packetId = csb.constId;
		csb.x = x;
		csb.y = y;
		csb.z = z;
		csb.mode = mode;
		csb.type = type;

		sendPacket!(csb)(s);
	}

	void sendClientPlayerUpdatePosOri(short x, short y, short z, ubyte yaw, ubyte pitch)
	{
		ClientPlayerUpdatePosOri cpupo;

		cpupo.packetId = cpupo.constId;
		cpupo.playerId = cast(byte)0xff;
		cpupo.x = x;
		cpupo.y = y;
		cpupo.z = z;
		cpupo.yaw = yaw;
		cpupo.pitch = pitch;

		sendPacket!(cpupo)(s);
	}

	void sendClientMessage(char[] msg)
	{
		ClientMessage cm;

		cm.packetId = cm.constId;
		cm.pad = 0xff;
		cm.message[0 .. msg.length] = msg;
		cm.message[msg.length .. $] = ' ';

		sendPacket!(cm)(s);
	}


protected:
	/*
	 *
	 * Protocol decoding functions.
	 *
	 */


	/**
	 * 0x00
	 */
	void serverIdentification(ServerIdentification *si)
	{
		ubyte ver = si.playerType;
		char[] name = removeTrailingSpaces(si.name);
		char[] motd = removeTrailingSpaces(si.motd);
		ubyte type = si.playerType;

		l.indentification(ver, name, motd, type);
	}

	/*
	 * Ping 0x01 and LevelIntialized 0x02 routed directly.
	 */

	/**
	 * 0x03
	 */
	void levelDataChunk(ServerLevelDataChunk *sldc)
	{
		short len = ntoh(sldc.length);

		if (len > sldc.data.length)
			throw new InvalidPacketException(sldc.packetId);

		inData ~= sldc.data[0 .. len];

		l.levelLoadUpdate(sldc.percent);
	}

	/**
	 * 0x04
	 */
	void levelFinalize(ServerLevelFinalize *slf)
	{
		// Get the level size
		short xSize = ntoh(slf.x);
		short ySize = ntoh(slf.y);
		short zSize = ntoh(slf.z);
		size_t size = uint.sizeof + xSize * ySize * zSize;


		// Need somewhere to store the uncompressed data
		auto ptr = cast(ubyte*)std.c.stdlib.malloc(size);
		if (!ptr)
			throw new ZlibException(etc.c.zlib.Z_MEM_ERROR);
		scope(exit)
			std.c.stdlib.free(ptr);
		ubyte[] decomp = ptr[0 .. size];

		// Used as arguments for zlib
		etc.c.zlib.z_stream zs;
		zs.next_in = inData.ptr;
		zs.avail_in = cast(uint)inData.length;
		zs.next_out = decomp.ptr;
		zs.avail_out = cast(uint)size;

		// Initialize zlib with argument struct
		int err = etc.c.zlib.inflateInit2(&zs, 15 + 16);
		if (err)
			throw new ZlibException(err);
		scope(exit)
			cast(void)etc.c.zlib.inflateEnd(&zs);

		// Do the decompressing
		err = etc.c.zlib.inflate(&zs, etc.c.zlib.Z_NO_FLUSH);
		switch (err) {
		case etc.c.zlib.Z_STREAM_END:
			// All ok!
			break;
		case etc.c.zlib.Z_DATA_ERROR:
			// Work around checksum errors
			if (zs.avail_out == 0 && zs.avail_in == 4)
				break;
			// Otherwise error!
		default:
			throw new ZlibException(err);
		}

		// No point in keeping the read data around
		delete inData;

		// Skip the size in the begining
		auto d = decomp[4 .. $];

		l.levelFinalize(xSize, ySize, zSize, d);
	}

	/**
	 * 0x06
	 */
	void setBlock(ServerSetBlock *ssb)
	{
		short x = ntoh(ssb.x);
		short y = ntoh(ssb.y);
		short z = ntoh(ssb.z);
		ubyte type = ssb.type;

		if (l !is null)
			l.setBlock(x, y, z, type);
	}

	/**
	 * 0x07
	 */
	void playerSpawn(ServerPlayerSpawn *sps)
	{
		auto id = sps.playerId;
		auto name = removeTrailingSpaces(sps.playerName);
		double x = cast(double)ntoh(sps.x) / 32.0;
		double y = cast(double)ntoh(sps.y) / 32.0;
		double z = cast(double)ntoh(sps.z) / 32.0;
		auto yaw = sps.yaw;
		auto pitch = sps.pitch;

		if (l !is null)
			l.playerSpawn(id, name, x, y, z, yaw, pitch);
	}

	/**
	 * 0x08
	 */
	void playerTeleport(ServerPlayerTeleport *spt)
	{
		auto id = spt.playerId;
		double x = cast(double)ntoh(spt.x) / 32.0;
		double y = cast(double)ntoh(spt.y) / 32.0;
		double z = cast(double)ntoh(spt.z) / 32.0;
		auto yaw = spt.yaw;
		auto pitch = spt.pitch;

		if (l !is null)
			l.playerMoveTo(id, x, y, z, yaw, pitch);
	}

	/**
	 * 0x09
	 */
	void playerUpdatePosOri(ServerPlayerUpdatePosOri *spupo)
	{
		auto id = spupo.playerId;
		double x = spupo.x / 32.0;
		double y = spupo.y / 32.0;
		double z = spupo.z / 32.0;
		auto yaw = spupo.yaw;
		auto pitch = spupo.pitch;

		if (l !is null)
			l.playerMove(id, x, y, z, yaw, pitch);
	}

	/**
	 * 0x0a
	 */
	void playerUpdatePos(ServerPlayerUpdatePos *spup)
	{
		auto id = spup.playerId;
		double x = spup.x / 32.0;
		double y = spup.y / 32.0;
		double z = spup.z / 32.0;

		if (l !is null)
			l.playerMove(id, x, y, z);
	}

	/**
	 * 0x0b
	 */
	void playerUpdateOri(ServerPlayerUpdateOri *spuo)
	{
		auto id = spuo.playerId;
		auto yaw = spuo.yaw;
		auto pitch = spuo.pitch;

		if (l !is null)
			l.playerMove(id, yaw, pitch);
	}

	/**
	 * 0x0c
	 */
	void playerDespawn(ServerPlayerDespawn *spd)
	{
		auto id = spd.playerId;

		if (l !is null)
			l.playerDespawn(id);
	}

	/**
	 * 0x0d
	 */
	void message(ServerMessage *sm)
	{
		byte player = sm.playerId;
		char[] msg = removeTrailingSpaces(sm.message);

		if (l !is null)
			l.message(player, msg);
	}

	/**
	 * 0x0e
	 */
	void disconnect(ServerDisconnect *sd)
	{
		char[] reason = removeTrailingSpaces(sd.reason);

		l.disconnect(reason);
	}

	/**
	 * 0x0f
	 */
	void playerType(ServerUpdateType *sut)
	{
		ubyte type = sut.type;

		l.playerType(type);
	}

	void packet(ubyte *pkg)
	{
		switch(*pkg) {
		case 0x00:
			auto p = cast(ServerIdentification*)pkg;
			serverIdentification(p);
			break;
		case 0x01:
			l.ping();
			break;
		case 0x02:
			l.levelInitialize();
			break;
		case 0x03:
			auto p = cast(ServerLevelDataChunk*)pkg;
			levelDataChunk(p);
			break;
		case 0x04:
			auto p = cast(ServerLevelFinalize*)pkg;
			levelFinalize(p);
			break;
		case 0x05: // Ignore
			break;
		case 0x06:
			auto p = cast(ServerSetBlock*)pkg;
			setBlock(p);
			break;
		case 0x07:
			auto p = cast(ServerPlayerSpawn*)pkg;
			playerSpawn(p);
			break;
		case 0x08:
			auto p = cast(ServerPlayerTeleport*)pkg;
			playerTeleport(p);
			break;
		case 0x09:
			auto p = cast(ServerPlayerUpdatePosOri*)pkg;
			playerUpdatePosOri(p);
			break;
		case 0x0a:
			auto p = cast(ServerPlayerUpdatePos*)pkg;
			playerUpdatePos(p);
			break;
		case 0x0b:
			auto p = cast(ServerPlayerUpdateOri*)pkg;
			playerUpdateOri(p);
			break;
		case 0x0c:
			auto p = cast(ServerPlayerDespawn*)pkg;
			playerDespawn(p);
			break;
		case 0x0d:
			auto p = cast(ServerMessage*)pkg;
			message(p);
			break;
		case 0x0e:
			auto p = cast(ServerDisconnect*)pkg;
			disconnect(p);
			break;
		case 0x0f:
			auto p = cast(ServerUpdateType*)pkg;
			playerType(p);
			break;
		default: // Error 
			assert(false);
		}
	}

	/*
	 *
	 * Socket functions.
	 *
	 */


	/**
	 * Called at start.
	 */
	int run()
	{
		try {
			connect(hostname, port);
			sendClientIdentification(username, verificationKey);

			while(true)
				loop();

		} catch (Exception e) {
			/// XXX: Do something better here.
		}

		return 0;
	}

	/**
	 * Main loop for receiving packages.
	 */
	void loop()
	{
		ubyte[] data;
		ubyte peek;
		int n;

		// Peek to see which packet it is
		n = receive((&peek)[0 .. 1], true);
		if (n <= 0)
			throw new ConnectionException("peek");
		if (peek >= serverPacketSizes.length)
			throw new InvalidPacketException(peek);

		// Get the length of this packet type
		auto len = serverPacketSizes[peek];
		if (len == 0)
			throw new InvalidPacketException();

		// Allocate a receiving packet from the C heap
		auto pkg = allocPacket(len, data);

		// Get the data from the socket into the packet
		for (int i; i < len; i += n) {
			n = receive(data[i .. len]);
			if (n <= 0)
				throw new ConnectionException("read");
		}

		pushPacket(pkg);
	}
}

private class ConnectionException : public Exception
{
	this(char[] str)
	{
		char[] s = format("Connection error (%s)", str);
		super(s);
	}
}

private class InvalidPacketException : public Exception
{
	this()
	{
		super("Invalid packet length");
	}

	this(ubyte b)
	{
		char[] s = format("Invalid packet type (0x%02x)", b);
		super(s);
	}
}

private template sendPacket(alias T)
{
	void sendPacket(Socket s)
	{
		s.send((cast(ubyte*)&T)[0 .. typeof(T).sizeof]);
	}
}
