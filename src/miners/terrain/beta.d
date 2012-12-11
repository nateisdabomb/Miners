// Copyright © 2011, Jakob Bornecrantz.  All rights reserved.
// See copyright notice in src/charge/charge.d (GPLv2 only).
module miners.terrain.beta;

import std.math : floor;

import charge.charge;

import miners.types;
import miners.options;
import miners.terrain.chunk;
import miners.terrain.common;
import miners.builder.interfaces;


final class BetaTerrain : Terrain
{
public:
	const int width = 16;
	const int depth = 16;
	int save_build_i;
	int save_build_j;
	int save_build_k;
	int xCenter;
	int zCenter;
	int rxOff;
	int rzOff;
	Region[depth][width] region;

	alias void delegate(Chunk c) NewChunkDg;
	NewChunkDg newChunkDg;

public:
	this(GameWorld w, Options opts, NewChunkDg dg, MeshBuilder builder)
	{
		this.rxOff = 0;
		this.rzOff = 0;
		super(w, opts, builder, opts.modernTextures);

		assert(dg !is null);

		newChunkDg = dg;

		// Make sure all state is setup correctly
		setCenter(0, 0, 0);
	}

	~this()
	{

	}

	override void breakApart()
	{
		foreach(ref row; region)
			foreach(ref r; row)
				breakApartAndNull(r);
		super.breakApart();
	}


	/*
	 *
	 * Block access functions.
	 *
	 */


	override final Block opIndex(int x, int y, int z)
	{
		Block b;
		if (y < 0)
			return b;
		if (y >= 128)
			return b;

		int xPos = x < 0 ? (x - 15) / 16 : x / 16;
		int zPos = z < 0 ? (z - 15) / 16 : z / 16;
		x = cast(uint)x % 16;
		z = cast(uint)z % 16;

		auto c = getChunk(xPos, zPos);
		if (c is null)
			return b;

		b.type = c.getTypePointerUnsafe(x, z)[y];
		b.meta = c.getTypePointerUnsafe(x, z)[y/2];

		if (y % 2 == 0)
			b.meta &= 0xf;
		else
			b.meta >>= 4;

		return b;
	}

	override final Block opIndexAssign(Block b, int x, int y, int z)
	{
		if (y < 0)
			return Block();
		if (y >= 128)
			return Block();

		int xPos = x < 0 ? (x - 15) / 16 : x / 16;
		int zPos = z < 0 ? (z - 15) / 16 : z / 16;
		x = cast(uint)x % 16;
		z = cast(uint)z % 16;

		auto c = getChunk(xPos, zPos);
		if (c is null)
			return b;

		c.getTypePointerUnsafe(x, z)[y] = b.type;

		auto ptr = &c.getMetaPointerUnsafe(x, z)[y/2];
		ubyte meta = *ptr;

		if (y % 2 == 0)
			*ptr = (meta & 0xf0) | (b.meta & 0x0f);
		else
			*ptr = cast(ubyte)(b.meta << 4) | (meta & 0x0f);

		return b;
	}


	/*
	 *
	 * Type & Meta access functions.
	 *
	 */


	/**
	 * Return the type for block at location.
	 */
	override final ubyte getType(int x, int y, int z)
	{
		if (y < 0)
			return 0;
		else if (y >= 128)
			return 0;

		int xPos = x < 0 ? (x - 15) / 16 : x / 16;
		int zPos = z < 0 ? (z - 15) / 16 : z / 16;
		x = cast(uint)x % 16;
		z = cast(uint)z % 16;

		return getTypeUnsafe(xPos, zPos, x, y, z);
	}

	/**
	 * Set the type for block at location.
	 */
	override final ubyte setType(ubyte type, int x, int y, int z)
	{
		if (y < 0)
			return 0;
		else if (y >= 128)
			return 0;

		int xPos = x < 0 ? (x - 15) / 16 : x / 16;
		int zPos = z < 0 ? (z - 15) / 16 : z / 16;
		x = cast(uint)x % 16;
		z = cast(uint)z % 16;

		auto ptr = getTypePointerUnsafe(xPos, zPos, x, z);
		if (ptr is null)
			return 0;
		return ptr[y] = type;
	}

	/**
	 * Returns block data, coords are relative to chunk specified
	 * by xPos, zPos.
	 */
	final ubyte getType(int xPos, int zPos, int x, int y, int z)
	{
		xPos += x < 0 ? (x - 15) / 16 : x / 16;
		zPos += z < 0 ? (z - 15) / 16 : z / 16;
		x = cast(uint)x % 16;
		z = cast(uint)z % 16;

		return getTypeUnsafe(xPos, zPos, x, y, z);
	}

	/**
	 * Returns block data, coords are relative to chunk specified
	 * by xPos, zPos. Coords must be within the chunk boarders.
	 */
	final ubyte getTypeUnsafe(int xPos, int zPos, int x, int y, int z)
	{
		auto c = getChunk(xPos, zPos);
		if (c is null)
			return 0;
		return c.getTypeUnsafe(x, y, z);
	}

	/**
	 * Get the pointer to the start of a row of block types.
	 *
	 * Coords in global coordinates, for beta terrain start is
	 * always the block on height 0.
	 */
	ubyte* getTypePointer(int x, int z)
	{
		auto xPos = x < 0 ? (x - 15) / 16 : x / 16;
		auto zPos = z < 0 ? (z - 15) / 16 : z / 16;

		x = x < 0 ? 15 - ((-x-1) % 16) : x % 16;
		z = z < 0 ? 15 - ((-z-1) % 16) : z % 16;

		return getTypePointerUnsafe(xPos, zPos, x, z);
	}

	/**
	 * See getTypePointer, the second pair of arguments are
	 * relative to the chunk specified by the first.
	 */
	ubyte* getTypePointer(int xPos, int zPos, int x, int z)
	{
		xPos += x < 0 ? (x - 15) / 16 : x / 16;
		zPos += z < 0 ? (z - 15) / 16 : z / 16;
		x = cast(uint)x % 16;
		z = cast(uint)z % 16;

		return getTypePointerUnsafe(xPos, zPos, x, z);
	}

	/**
	 * See getTypePointer, the second pair of arguments are
	 * relative to the chunk specified by the first. Access is unsafe.
	 */
	ubyte* getTypePointerUnsafe(int xPos, int zPos, int x, int z)
	{
		auto c = getChunk(xPos, zPos);
		if (c is null)
			return null;
		return c.getTypePointerUnsafe(x, z);
	}

	/**
	 * See getTypePointer but returns meta data.
	 */
	ubyte* getMetaPointer(int x, int z)
	{
		auto xPos = x < 0 ? (x - 15) / 16 : x / 16;
		auto zPos = z < 0 ? (z - 15) / 16 : z / 16;

		x = x < 0 ? 15 - ((-x-1) % 16) : x % 16;
		z = z < 0 ? 15 - ((-z-1) % 16) : z % 16;

		return getMetaPointerUnsafe(xPos, zPos, x, z);
	}

	/**
	 * See getTypePointer with chunk local coords but returns meta data.
	 */
	ubyte* getMetaPointer(int xPos, int zPos, int x, int z)
	{
		xPos += x < 0 ? (x - 15) / 16 : x / 16;
		zPos += z < 0 ? (z - 15) / 16 : z / 16;
		x = cast(uint)x % 16;
		z = cast(uint)z % 16;

		return getMetaPointerUnsafe(xPos, zPos, x, z);
	}

	/**
	 * See getTypePointerUnsafe with chunk local coords but returns meta data.
	 */
	ubyte* getMetaPointerUnsafe(int xPos, int zPos, int x, int z)
	{
		auto c = getChunk(xPos, zPos);
		if (c is null)
			return null;
		return c.getMetaPointerUnsafe(x, z);
	}


	/*
	 *
	 * Dirty managment
	 *
	 */


	/**
	 * Marks the given volume as dirty.
	 */
	override final void markVolumeDirty(int x, int y, int z, uint sx, uint sy, uint sz)
	{
		// We must mark all chunks that neighbor the changed area.
		 x -= 1;  y -= 1;  z -= 1;
		sx += 2; sy += 2; sz += 2;

		int xStart = x < 0 ? (x - 15) / 16 : x / 16;
		int zStart = z < 0 ? (z - 15) / 16 : z / 16;

		x += sx;
		z += sz;
		int xStop = x < 0 ? (x - 15) / 16 : x / 16;
		int zStop = z < 0 ? (z - 15) / 16 : z / 16;

		for (x = xStart; x <= xStop; x++) {
			for (z = zStart; z <= zStop; z++) {
				auto c = getChunk(x, z);
				if (c is null)
					continue;
				c.markDirty(y, sy);
			}
		}
	}


	/*
	 *
	 * Direct Chunk access functions.
	 *
	 */


	/**
	 * Get a chunk, may return null if chunk is not loaded.
	 * Coords in chunk space.
	 */
	final Chunk getChunk(int x, int z)
	{
		auto r = getRegion(x, z);
		if (r is null)
			return null;

		return r.getChunk(x, z);
	}

	/**
	 * Creates and if a level was specified loads data.
	 * Coords in chunk space.
	 */
	Chunk loadChunk(int x, int z)
	{
		auto rx = cast(int)floor(x/32.0) - rxOff;
		auto rz = cast(int)floor(z/32.0) - rzOff;

		if (rx < 0 || rz < 0)
			assert(null is "tried to load chunk outside of regions");
		else if (rx >= width || rz >= depth)
			assert(null is "tried to load chunk outside of regions");

		auto r = region[rx][rz];
		if (r is null)
			region[rx][rz] = r = new Region(this, rx+rxOff, rz+rzOff);

		auto c = r.createChunkUnsafe(x, z);
		if (c.loaded)
			return c;

		newChunkDg(c);

		return c;
	}


	/*
	 *
	 * Inhereted terrain methods.
	 *
	 */


	/**
	 * Set the current center from which chunks are built.
	 * Coords in chunk space.
	 */
	override void setCenter(int xNew, int yNew, int zNew)
	{
		setCenterRegions(xNew, zNew);

		xCenter = xNew;
		zCenter = zNew;
		for (int x; x < width; x++) {
			for (int z; z < depth; z++) {
				auto r = region[x][z];
				if (r is null)
					continue;

				r.unbuildRadi(xCenter, zCenter, view_radii);
			}
		}

		resetBuild();
	}

	/**
	 * Sets the radius in chunks of which chunks should
	 * be built and rendered.
	 */
	override void setViewRadii(int radii)
	{
		if (radii < view_radii) {
			for (int x; x < width; x++) {
				for (int z; z < depth; z++) {
					auto r = region[x][z];
					if (r is null)
						continue;

					r.unbuildRadi(xCenter, zCenter, radii);
				}
			}
		}
		view_radii = radii;
	}

	/**
	 * Which type of mesh should be built, needs to match up
	 * with the capabilities of the current renderer.
	 */
	override void setBuildType(TerrainBuildTypes type, string name)
	{
		if (type == currentBuildType)
			return;

		// Unbuild all the meshes.
		unbuildAll();

		// Do the change
		doBuildTypeChange(type);

		// Build at least one chunk
		buildOne();
	}

	/**
	 * Build a single chunk, returns false if no one was built.
	 */
	override bool buildOne()
	{
		bool dob(int x, int z) {
			bool valid = true;
			x += xCenter;
			z += zCenter;

			auto c = getChunk(x, z);
			if (c !is null && !c.shouldBuild())
				return false;

			for (int i = x-1; i < x+2; i++) {
				for (int j = z-1; j < z+2; j++) {
					auto ch = loadChunk(i, j);
					if (ch is null)
						valid = false;
					else
						valid = valid && ch.valid;
				}
			}

			if (valid)
				getRegion(x, z).buildUnsafe(x, z);

			return true;
		}

		int offset(int i) { i++; return i & 1 ? -(i >> 1) : (i >> 1); }
		int num(int i) { i++; return i | 1; }

		// Restart from save position
		int i = save_build_i;
		int j = save_build_j;
		int k = save_build_k;
		for (; i < view_radii * 2 - 1; i++) {
			for (; j < num(i); j++) {
				for (; k < num(i); k++) {
					if (dob(offset(j), offset(k))) {
						save_build_i = i;
						save_build_j = j;
						save_build_k = k+1;
						return true;
					}
				}
				k = 0;
			}
			j = 0;
		}

		// Once we are done skip the loops.
		save_build_i = i;
		save_build_j = j;
		save_build_k = k;
		return false;
	}

	/**
	 * Start over from the begining when building chunks.
	 */
	override void resetBuild()
	{
		// Reset the saved position for the buildOne function
		save_build_i = 0;
		save_build_j = 0;
		save_build_k = 0;
	}

	/**
	 * Unbuild all the meshes.
	 */
	override void unbuildAll()
	{
		for (int x; x < width; x++) {
			for (int z; z < depth; z++) {
				auto r = region[x][z];
				if (r is null)
					continue;
				r.unbuildAll();
			}
		}

		resetBuild();
	}


protected:
	void setCenterRegions(int xNew, int zNew)
	{
		auto rxNew = cast(int)floor(cast(float)xNew / Region.width);
		auto rzNew = cast(int)floor(cast(float)zNew / Region.depth);

		int rxNewOff = rxNew - (width / 2);
		int rzNewOff = rzNew - (depth / 2);

		if (rxNewOff == rxOff && rzNewOff == rzOff)
			return;

		Region[depth][width] copy;

		for (int x; x < width; x++) {
			for (int z; z < depth; z++) {
				auto r = region[x][z];
				if (r is null)
					continue;
				int rxPos = r.xPos - rxNewOff;
				int rzPos = r.zPos - rzNewOff;
				if (rxPos < 0 || rzPos < 0 || rxPos >= width || rzPos >= depth) {
					if (r !is null)
						r.breakApart();
				} else {
					copy[rxPos][rzPos] = r;
				}
			}
		}

		rxOff = rxNewOff;
		rzOff = rzNewOff;
		for (int x; x < width; x++)
			for (int z; z < depth; z++)
				region[x][z] = copy[x][z];
	}

	final Region getRegion(int x, int z)
	{
		auto rx = cast(int)floor(x/32.0) - rxOff;
		auto rz = cast(int)floor(z/32.0) - rzOff;

		if (rx < 0 || rz < 0)
			return null;
		else if (rx >= width || rz >= depth)
			return null;

		return region[rx][rz];
	}
}

final class Region
{
public:
	const int width = 32;
	const int depth = 32;
	Chunk[width][depth] chunk;

	BetaTerrain bt;

	int numBuilt;

	/*
	 * The same used as as in the filename.
	 */
	int xPos;
	int zPos;

	/*
	 * Used to go from a global chunk position to a local one.
	 */
	int xOff;
	int zOff;

public:
	this(BetaTerrain bt, int xPos, int zPos)
	{
		this.bt = bt;
		this.xPos = xPos;
		this.zPos = zPos;

		xOff = xPos * 32;
		zOff = zPos * 32;
	}

	~this()
	{
	}

	void breakApart()
	{
		foreach(ref row; chunk)
			foreach(ref c; row)
				breakApartAndNull(c);
	}


	/*
	 *
	 * Direct Chunk access.
	 *
	 */


	/**
	 * Get the chunk at global chunk coords unsafely.
 	 */
	final Chunk getChunk(int x, int z)
	{
		x -= xOff;
		z -= zOff;

		if (x < 0 || z < 0)
			return null;
		else if (x >= width || z >= depth)
			return null;

		return chunk[x][z];
	}

	/**
	 * Get the chunk at global chunk coords, access is unsafe.
 	 */
	final Chunk getChunkUnsafe(int x, int z)
	{
		x -= xOff;
		z -= zOff;

		return chunk[x][z];
	}

	/**
	 * Makes sure that a chunk is created at global coords given.
	 * Does not overwrite chunks already there. Access is unsafe.
	 */
	final Chunk createChunkUnsafe(int x, int z)
	{
		x -= xOff;
		z -= zOff;

		if (chunk[x][z] !is null)
			return chunk[x][z];

		return chunk[x][z] = new Chunk(bt, bt.w, x+xOff, z+zOff);
	}


	/*
	 *
	 * Chunk builder functions.
	 *
	 */


	/**
	 * Build chunk at global chunk coord, access is unsafe.
	 */
	final void buildUnsafe(int x, int z)
	{
		auto c = getChunkUnsafe(x, z);
		if (c is null || !c.shouldBuild())
			return;

		if (c.gfx) {
			c.unbuild();
			numBuilt--;
		}

		c.build();
		numBuilt++;
		c.dirty = false;
	}

	/**
	 * Unbuild a chunk at global chunk coord.
	 */
	final void unbuild(int x, int z)
	{
		if (numBuilt <= 0)
			return;

		auto c = getChunk(x, z);
		if (c is null || !c.gfx)
			return;

		c.unbuild();
		numBuilt--;
	}

	/**
	 * Unbuild all chunks.
	 */
	final void unbuildAll()
	{
		if (numBuilt <= 0)
			return;

		for (int x; x < width; x++) {
			for (int z; z < depth; z++) {
				auto c = chunk[x][z];
				if (c is null)
					continue;
				c.unbuild();
			}
		}

		numBuilt = 0;
	}

	/**
	 * Unbuild all chunks outside the radiis of the global coord given.
	 */
	final void unbuildRadi(int xCenter, int zCenter, int view_radi)
	{
		if (numBuilt <= 0)
			return;

		int r = view_radi - 1;
		for (int x; x < width; x++) {
			for (int z; z < depth; z++) {
				auto xp = x + xOff;
				auto zp = z + zOff;

				auto c = chunk[x][z];
				if (c is null || !c.gfx)
					continue;

				if (xp < xCenter - r || xp > xCenter + r ||
				    zp < zCenter - r || zp > zCenter + r) {
					c.unbuild();
					numBuilt--;
				}
			}
		}
	}
}
