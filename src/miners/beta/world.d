// Copyright © 2011, Jakob Bornecrantz.  All rights reserved.
// See copyright notice in src/charge/charge.d (GPLv2 only).
module miners.beta.world;

import charge.charge;

import miners.world;
import miners.options;
import miners.terrain.beta;
import miners.terrain.chunk;
import miners.terrain.common;
import miners.builder.beta;
import miners.importer.info;
import miners.importer.blocks;


/**
 * World containing a infite beta world.
 */
class BetaWorld : World
{
public:
	BetaTerrain bt;
	string dir;

public:
	this(MinecraftLevelInfo *info, Options opts)
	{
		this.spawn = info ? info.spawn : Point3d(0, 64, 0);
		this.dir = info ? info.dir : null;
		super(opts);

		auto builder = new BetaMeshBuilder();
		t = bt = new BetaTerrain(this, opts, &newChunk, builder);

		// Find the actuall spawn height
		auto x = cast(int)spawn.x;
		auto y = cast(int)spawn.y;
		auto z = cast(int)spawn.z;
		auto xPos = x < 0 ? (x - 15) / 16 : x / 16;
		auto yPos = y < 0 ? (y - 15) / 16 : y / 16;
		auto zPos = z < 0 ? (z - 15) / 16 : z / 16;

		bt.setCenter(xPos, zPos, zPos);
		bt.loadChunk(xPos, zPos);

		auto p = bt.getTypePointer(x, z);
		for (int i = y; i < 128; i++) {
			if (tile[p[i]].filled)
				continue;
			if (tile[p[i+1]].filled)
				continue;

			spawn.y = i;
			break;
		}
	}

	void newChunk(Chunk c)
	{
		// Don't load chunk data if no level was specified.
		if (dir is null)
			return;

		ubyte *blocks;
		ubyte *data;
		if (getBetaBlocksForChunk(dir, c.xPos, c.zPos, blocks, data)) {
			c.giveBlocksAndData(blocks, data);
			c.valid = true;
		}
		c.loaded = true;

		// Make the neighbors be built again.
		c.markNeighborsDirty();
	}
}
