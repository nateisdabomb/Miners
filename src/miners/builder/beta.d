// Copyright © 2012, Jakob Bornecrantz.  All rights reserved.
// See copyright notice in src/charge/charge.d (GPLv2 only).
module miners.builder.beta;

import miners.defines;

import miners.builder.emit;
import miners.builder.quad;
import miners.builder.types;
import miners.builder.builder;
import miners.builder.helpers;
import miners.builder.workspace;


/*
 *
 * MeshBuilder
 *
 */


class BetaMeshBuilder : MeshBuilderBuildArray
{
	this()
	{
		super(.buildArray.ptr, .tile.ptr);
	}
}


/*
 *
 * Data
 *
 */


private alias BuildBlockDescriptor.toTex toTex;


BuildBlockDescriptor tile[256] = [
	{ false, toTex(  0,  0 ), toTex(  0,  0 ) }, // air                   // 0
	{  true, toTex(  1,  0 ), toTex(  1,  0 ) }, // stone
	{  true, toTex(  3,  0 ), toTex(  0,  0 ) }, // grass
	{  true, toTex(  2,  0 ), toTex(  2,  0 ) }, // dirt
	{  true, toTex(  0,  1 ), toTex(  0,  1 ) }, // clobb
	{  true, toTex(  4,  0 ), toTex(  4,  0 ) }, // wooden plank
	{ false, toTex( 15,  0 ), toTex( 15,  0 ) }, // sapling
	{  true, toTex(  1,  1 ), toTex(  1,  1 ) }, // bedrock
	{ false, toTex( 15, 13 ), toTex( 15, 13 ) }, // water                 // 8
	{ false, toTex( 15, 13 ), toTex( 15, 13 ) }, // spring water
	{  true, toTex( 15, 15 ), toTex( 15, 15 ) }, // lava
	{  true, toTex( 15, 15 ), toTex( 15, 15 ) }, // spring lava
	{  true, toTex(  2,  1 ), toTex(  2,  1 ) }, // sand
	{  true, toTex(  3,  1 ), toTex(  3,  1 ) }, // gravel
	{  true, toTex(  0,  2 ), toTex(  0,  2 ) }, // gold ore
	{  true, toTex(  1,  2 ), toTex(  1,  2 ) }, // iron ore
	{  true, toTex(  2,  2 ), toTex(  2,  2 ) }, // coal ore              // 16
	{  true, toTex(  4,  1 ), toTex(  5,  1 ) }, // log
	{ false, toTex(  4,  3 ), toTex(  4,  3 ) }, // leaves
	{  true, toTex(  0,  3 ), toTex(  0,  3 ) }, // sponge
	{ false, toTex(  1,  3 ), toTex(  1,  3 ) }, // glass
	{  true, toTex(  0, 10 ), toTex(  0, 10 ) }, // lapis lazuli ore
	{  true, toTex(  0,  9 ), toTex(  0,  9 ) }, // lapis lazuli block
	{  true, toTex( 13,  2 ), toTex( 14,  3 ) }, // dispenser
	{  true, toTex(  0, 12 ), toTex(  0, 11 ) }, // sand Stone            // 24
	{  true, toTex( 10,  4 ), toTex( 10,  4 ) }, // note block
	{ false, toTex(  0,  4 ), toTex(  0,  4 ) }, // bed
	{ false, toTex(  0,  4 ), toTex(  0,  4 ) }, // powered rail
	{ false, toTex(  0,  4 ), toTex(  0,  4 ) }, // detector rail
	{ false, toTex(  0,  4 ), toTex(  0,  4 ) }, // n/a
	{ false, toTex(  0,  4 ), toTex(  0,  4 ) }, // web
	{ false, toTex(  7,  2 ), toTex(  7,  2 ) }, // tall grass
	{ false, toTex(  7,  3 ), toTex(  7,  3 ) }, // dead shrub            // 32
	{ false, toTex(  0,  4 ), toTex(  0,  4 ) }, // n/a
	{ false, toTex(  0,  4 ), toTex(  0,  4 ) }, // n/a
	{  true, toTex(  0,  4 ), toTex(  0,  4 ) }, // wool
	{ false, toTex(  0,  4 ), toTex(  0,  4 ) }, // n/a
	{ false, toTex( 13,  0 ), toTex( 13,  0 ) }, // yellow flower
	{ false, toTex( 12,  0 ), toTex( 12,  0 ) }, // red rose
	{ false, toTex( 13,  1 ), toTex(  0,  0 ) }, // brown myshroom
	{ false, toTex( 12,  1 ), toTex(  0,  0 ) }, // red mushroom          // 40
	{  true, toTex(  7,  1 ), toTex(  7,  1 ) }, // gold block
	{  true, toTex(  6,  1 ), toTex(  6,  1 ) }, // iron block
	{  true, toTex(  5,  0 ), toTex(  6,  0 ) }, // double slab
	{ false, toTex(  5,  0 ), toTex(  6,  0 ) }, // slab
	{  true, toTex(  7,  0 ), toTex(  7,  0 ) }, // brick block
	{  true, toTex(  8,  0 ), toTex(  9,  0 ) }, // tnt
	{  true, toTex(  3,  2 ), toTex(  4,  0 ) }, // bookshelf
	{  true, toTex(  4,  2 ), toTex(  4,  2 ) }, // moss stone            // 48
	{  true, toTex(  5,  2 ), toTex(  5,  2 ) }, // obsidian
	{ false, toTex(  0,  5 ), toTex(  0,  5 ) }, // torch
	{ false, toTex(  0,  0 ), toTex(  0,  0 ) }, // fire
	{ false, toTex(  1,  4 ), toTex(  1,  4 ) }, // monster spawner
	{ false, toTex(  4,  0 ), toTex(  4,  0 ) }, // wooden stairs
	{  true, toTex( 10,  1 ), toTex(  9,  1 ) }, // chest
	{ false, toTex(  4, 10 ), toTex(  4, 10 ) }, // redstone wire
	{  true, toTex(  2,  3 ), toTex(  2,  3 ) }, // diamond ore           // 56
	{  true, toTex(  8,  1 ), toTex(  8,  1 ) }, // diamond block
	{  true, toTex( 11,  3 ), toTex( 11,  2 ) }, // crafting table
	{ false, toTex(  0,  0 ), toTex(  0,  0 ) }, // crops
	{  true, toTex(  2,  0 ), toTex(  6,  5 ) }, // farmland
	{  true, toTex( 13,  2 ), toTex( 14,  3 ) }, // furnace
	{  true, toTex( 13,  2 ), toTex( 14,  3 ) }, // burning furnace
	{ false, toTex(  4,  0 ), toTex(  0,  0 ) }, // sign post
	{ false, toTex(  1,  5 ), toTex(  1,  6 ) }, // wooden door           // 64
	{ false, toTex(  3,  5 ), toTex(  3,  5 ) }, // ladder
	{ false, toTex(  0,  8 ), toTex(  0,  8 ) }, // rails
	{ false, toTex(  0,  1 ), toTex(  0,  1 ) }, // clobblestone stairs
	{ false, toTex(  4,  0 ), toTex(  4,  0 ) }, // wall sign
	{ false, toTex(  0,  0 ), toTex(  0,  0 ) }, // lever
	{ false, toTex(  1,  0 ), toTex(  1,  0 ) }, // stone pressure plate
	{ false, toTex(  2,  5 ), toTex(  2,  6 ) }, // iron door
	{ false, toTex(  4,  0 ), toTex(  4,  0 ) }, // wooden pressure plate // 72
	{  true, toTex(  3,  3 ), toTex(  3,  3 ) }, // redostone ore
	{  true, toTex(  3,  3 ), toTex(  3,  3 ) }, // glowing rstone ore
	{ false, toTex(  3,  7 ), toTex(  3,  7 ) }, // redstone torch off
	{ false, toTex(  3,  6 ), toTex(  3,  6 ) }, // redstone torch on
	{ false, toTex(  1,  0 ), toTex(  1,  0 ) }, // stone button
	{ false, toTex(  2,  4 ), toTex(  2,  4 ) }, // snow
	{  true, toTex(  3,  4 ), toTex(  3,  4 ) }, // ice
	{  true, toTex(  2,  4 ), toTex(  2,  4 ) }, // snow block            // 80
	{ false, toTex(  6,  4 ), toTex(  5,  4 ) }, // cactus
	{  true, toTex(  8,  4 ), toTex(  8,  4 ) }, // clay block
	{ false, toTex(  9,  4 ), toTex(  0,  0 ) }, // sugar cane
	{  true, toTex( 10,  4 ), toTex( 11,  4 ) }, // jukebox
	{ false, toTex(  4,  0 ), toTex(  4,  0 ) }, // fence
	{  true, toTex(  6,  7 ), toTex(  6,  6 ) }, // pumpkin
	{  true, toTex(  7,  6 ), toTex(  7,  6 ) }, // netherrack
	{  true, toTex(  8,  6 ), toTex(  8,  6 ) }, // soul sand             // 88
	{  true, toTex(  9,  6 ), toTex(  9,  6 ) }, // glowstone block
	{ false, toTex(  0,  0 ), toTex(  0,  0 ) }, // portal
	{  true, toTex(  6,  7 ), toTex(  6,  6 ) }, // jack-o-lantern
	{ false, toTex( 10,  7 ), toTex(  9,  7 ) }, // cake block
	{ false, toTex(  3,  8 ), toTex(  3,  8 ) }, // redstone repeater off
	{ false, toTex(  3,  9 ), toTex(  3,  9 ) }, // redstone repeater on
	{ false, toTex(  0,  0 ), toTex(  0,  0 ) }, // n/a
	{ false, toTex(  4,  5 ), toTex(  4,  5 ) }, // trap door             // 96
];

BuildBlockDescriptor grassSideTile =
	{  true, toTex( 0,  0 ), toTex( 0,  0 ) }; // side grass

BuildBlockDescriptor snowyGrassBlock =
	{  true, toTex( 4,  4 ), toTex( 2,  4 ) }; // snowy grass

BuildBlockDescriptor woolTile[16] = [
	{  true, toTex(  0,  4 ), toTex(  0,  4 ) }, // white                // 0
	{  true, toTex(  2, 13 ), toTex(  2, 13 ) }, // orange
	{  true, toTex(  2, 12 ), toTex(  2, 12 ) }, // magenta
	{  true, toTex(  2, 11 ), toTex(  2, 11 ) }, // light blue
	{  true, toTex(  2, 10 ), toTex(  2, 10 ) }, // yellow
	{  true, toTex(  2,  9 ), toTex(  2,  9 ) }, // light green
	{  true, toTex(  2,  8 ), toTex(  2,  8 ) }, // pink
	{  true, toTex(  2,  7 ), toTex(  2,  7 ) }, // grey
	{  true, toTex(  1, 14 ), toTex(  1, 14 ) }, // light grey            // 8
	{  true, toTex(  1, 13 ), toTex(  1, 13 ) }, // cyan
	{  true, toTex(  1, 12 ), toTex(  1, 12 ) }, // purple
	{  true, toTex(  1, 11 ), toTex(  1, 11 ) }, // blue
	{  true, toTex(  1, 10 ), toTex(  1, 10 ) }, // brown
	{  true, toTex(  1,  9 ), toTex(  1,  9 ) }, // dark green
	{  true, toTex(  1,  8 ), toTex(  1,  8 ) }, // red
	{  true, toTex(  1,  7 ), toTex(  1,  7 ) }, // black
];

BuildBlockDescriptor woodTile[3] = [
	{  true, toTex(  4,  1 ), toTex(  5,  1 ) }, // normal,                // 0
	{  true, toTex(  4,  7 ), toTex(  5,  1 ) }, // spruce
	{  true, toTex(  5,  7 ), toTex(  5,  1 ) }, // birch
];

BuildBlockDescriptor saplingTile[4] = [
	{ false, toTex( 15,  0 ), toTex( 15,  0 ) }, // normal
	{ false, toTex( 15,  3 ), toTex( 15,  3 ) }, // spruce
	{ false, toTex( 15,  4 ), toTex( 15,  4 ) }, // birch
	{ false, toTex( 15,  0 ), toTex( 15,  0 ) }, // normal
];

BuildBlockDescriptor tallGrassTile[4] = [
	{ false, toTex(  7,  3 ), toTex(  7,  3 ) }, // dead shrub
	{ false, toTex(  7,  2 ), toTex(  7,  2 ) }, // tall grass
	{ false, toTex(  8,  3 ), toTex(  8,  3 ) }, // fern
];

BuildBlockDescriptor craftingTableAltTile =
	{  true, toTex( 12,  3 ), toTex( 11,  2 ) }; // crafting table

BuildBlockDescriptor slabTile[4] = [
	{  true, toTex(  5,  0 ), toTex(  6,  0 ) }, // stone,                // 0
	{  true, toTex(  0, 12 ), toTex(  0, 11 ) }, // sandstone
	{  true, toTex(  4,  0 ), toTex(  4,  0 ) }, // wooden plank
	{  true, toTex(  0,  1 ), toTex(  0,  1 ) }, // clobb
];

BuildBlockDescriptor cropsTile[8] = [
	{ false, toTex(  8,  5 ), toTex(  0,  5 ) }, // crops 0                  // 0
	{ false, toTex(  9,  5 ), toTex(  0,  5 ) }, // crops 1
	{ false, toTex( 10,  5 ), toTex(  0,  5 ) }, // crops 2
	{ false, toTex( 11,  5 ), toTex(  0,  5 ) }, // crops 3
	{ false, toTex( 12,  5 ), toTex(  0,  5 ) }, // crops 4
	{ false, toTex( 13,  5 ), toTex(  0,  5 ) }, // crops 5
	{ false, toTex( 14,  5 ), toTex(  0,  5 ) }, // crops 6
	{ false, toTex( 15,  5 ), toTex(  0,  5 ) }, // crops 7
];

BuildBlockDescriptor farmlandTile[2] = [
	{  true, toTex(  2,  0 ), toTex(  7,  5 ) }, // farmland dry          // 0
	{  true, toTex(  2,  0 ), toTex(  6,  5 ) }, // farmland wet
];

BuildBlockDescriptor furnaceFrontTile[2] = [
	{  true, toTex( 12,  2 ), toTex( 14,  3 ) }, // furnace
	{  true, toTex( 13,  3 ), toTex( 14,  3 ) }, // burning furnace
];

BuildBlockDescriptor dispenserFrontTile =
	{  true, toTex( 14,  2 ), toTex( 14,  3 ) }; // dispenser

BuildBlockDescriptor pumpkinFrontTile =
	{  true, toTex(  7,  7 ), toTex(  6,  6 ) }; // pumpkin

BuildBlockDescriptor jackolanternFrontTile =
	{  true, toTex(  8,  7 ), toTex(  6,  6 ) }; // jack-o-lantern

BuildBlockDescriptor cactusBottomTile =
	{ false, toTex(  7,  4 ), toTex(  7,  4 ) }; // cactus

BuildBlockDescriptor leavesTile[] = [
	{ false, toTex(  4,  3 ), toTex(  4,  3 ) }, // normal leaves
	{ false, toTex(  4,  8 ), toTex(  4,  8 ) }, // spruce leaves

	// (9,9) and (9,10) are created in applyStaticBiome()
	{ false, toTex(  9,  9 ), toTex(  9,  9 ) }, // birch leaves
	{ false, toTex(  9, 10 ), toTex(  9, 10 ) }, // other leaves
];

enum RedstoneWireType {
	Crossover,
	Line,
	Corner,
	Tjunction
};

BuildBlockDescriptor redstoneWireTile[2][4] = [
	// inactive
	[
		{ false, toTex(  4, 10 ), toTex(  4, 10 ) }, // crossover
		{ false, toTex(  5, 10 ), toTex(  5, 10 ) }, // line
		{ false, toTex(  6, 10 ), toTex(  6, 10 ) }, // corner
		{ false, toTex(  7, 10 ), toTex(  7, 10 ) }, // T-junction
	],
	// active
	[
		{ false, toTex(  4, 11 ), toTex(  4, 11 ) }, // crossover
		{ false, toTex(  5, 11 ), toTex(  5, 11 ) }, // line
		{ false, toTex(  6, 11 ), toTex(  6, 11 ) }, // corner
		{ false, toTex(  7, 11 ), toTex(  7, 11 ) }, // T-junction
	]
];

BuildBlockDescriptor cakeTile[2] = [
	{ false, toTex( 11,  7 ), toTex( 11,  7 ) }, // cake cut side
	{ false, toTex( 12,  7 ), toTex( 12,  7 ) }, // cake bottom
];

BuildBlockDescriptor chestTile[6] = [
	{  true, toTex( 10,  1 ), toTex(  9,  1 ) }, // single chest
	{  true, toTex( 11,  1 ), toTex(  9,  1 ) }, // single chest front
	{  true, toTex(  9,  2 ), toTex(  9,  1 ) }, // double chest front left
	{  true, toTex( 10,  2 ), toTex(  9,  1 ) }, // double chest front right
	{  true, toTex(  9,  3 ), toTex(  9,  1 ) }, // double chest back left
	{  true, toTex( 10,  3 ), toTex(  9,  1 ) }, // double chest back right
];

BuildBlockDescriptor railTile[5] = [
	{ false, toTex(  0,  7 ), toTex(  0,  7 ) }, // rails corner
	{ false, toTex(  0,  8 ), toTex(  0,  8 ) }, // rails line
	{ false, toTex(  3, 10 ), toTex(  3, 10 ) }, // powered rail off
	{ false, toTex(  3, 11 ), toTex(  3, 11 ) }, // powered rail on
	{ false, toTex(  3, 12 ), toTex(  3, 12 ) }, // detector rail
];

BuildBlockDescriptor bedTile[6] = [
	{ false, toTex(  0,  0 ), toTex(  6,  8 ) }, // blanket top
	{ false, toTex(  6,  9 ), toTex(  0,  0 ) }, // blanket side
	{ false, toTex(  5,  9 ), toTex(  0,  0 ) }, // blanket back
	{ false, toTex(  0,  0 ), toTex(  7,  8 ) }, // cushion top
	{ false, toTex(  7,  9 ), toTex(  0,  0 ) }, // cushion side
	{ false, toTex(  8,  9 ), toTex(  0,  0 ) }, // cushion front
];


/*
 *
 * Builder functions.
 *
 */


void air(Packer *p, int x, int y, int z, ubyte, WorkspaceData *data)
{
	// Nothing just return.
}


void solid(Packer *p, int x, int y, int z, ubyte type, WorkspaceData *data)
{
	auto dec = &tile[type];
	solidDec(p, data, dec, x, y, z);
}


void sapling(Packer *p, int x, int y, int z, ubyte, WorkspaceData *data)
{
	auto d = data.getDataUnsafe(x, y, z);
	auto dec = &saplingTile[d & 3];
	diagonalSprite(p, x, y, z, dec);
}


void grass(Packer *p, int x, int y, int z, ubyte, WorkspaceData *data)
{
	int set = data.getSolidSet(x, y, z);
	auto grassDec = &tile[2];
	auto dirtDec = &tile[3];
	auto snowDec = &snowyGrassBlock;
	auto side = &grassSideTile;

	if (data.get(x, y + 1, z) == 78 /* snow */)
		return makeXYZ(p, data, snowDec, x, y, z, set & ~sideMask.YN);

	makeXYZ(p, data, grassDec, x, y, z, set & (sideMask.YN | sideMask.YP));


	if (set & sideMask.XN) {
		auto type = data.get(x-1, y-1, z);
		auto dec = type == 2 ? side : grassDec;
		makeXZ(p, data, dec, x, y, z, sideNormal.XN);
	}

	if (set & sideMask.XP) {
		auto type = data.get(x+1, y-1, z);
		auto dec = type == 2 ? side : grassDec;
		makeXZ(p, data, dec, x, y, z, sideNormal.XP);
	}

	if (set & sideMask.ZN) {
		auto type = data.get(x, y-1, z-1);
		auto dec = type == 2 ? side : grassDec;
		makeXZ(p, data, dec, x, y, z, sideNormal.ZN);
	}

	if (set & sideMask.ZP) {
		auto type = data.get(x, y-1, z+1);
		auto dec = type == 2 ? side : grassDec;
		makeXZ(p, data, dec, x, y, z, sideNormal.ZP);
	}
}


void water(Packer *packerPrev, int x, int y, int z, ubyte, WorkspaceData *data)
{
	auto p = packerPrev.next;
	assert(p !is null);
	int set = data.getSolidOrTypesSet(8, 9, x, y, z);
	auto dec = &tile[8];
	ubyte tex = calcTextureXZ(dec);

	int x1 = x, x2 = x+1;
	int z1 = z, z2 = z+1;

	const shift = VERTEX_SIZE_BIT_SHIFT;
	x1 <<= shift;
	x2 <<= shift;
	z1 <<= shift;
	z2 <<= shift;

	int y1 = y, y2 = y + 1;
	y1 <<= shift;
	y2 <<= shift;

	auto aboveType = data.get(x, y+1, z);
	if (aboveType != 8 && aboveType != 9) {
		set |= sideMask.YP;
		y2 -= 2;
	}

	if (set & sideMask.XN)
		emitQuadXZN(p, x1, x1, y1, y2, z1, z2, tex, sideNormal.XN);
	if (set & sideMask.XP)
		emitQuadXZP(p, x2, x2, y1, y2, z1, z2, tex, sideNormal.XP);

	if (set & sideMask.YN)
		emitQuadYN(p, x1, x2, y1, z1, z2, tex, sideNormal.YN);
	if (set & sideMask.YP)
		emitQuadYP(p, x1, x2, y2, z1, z2, tex, sideNormal.YP);

	if (set & sideMask.ZN)
		emitQuadXZN(p, x1, x2, y1, y2, z1, z1, tex, sideNormal.ZN);
	if (set & sideMask.ZP)
		emitQuadXZP(p, x1, x2, y1, y2, z2, z2, tex, sideNormal.ZP);
}


void wood(Packer *p, int x, int y, int z, ubyte, WorkspaceData *data)
{
	auto dec = &woodTile[data.getDataUnsafe(x, y, z)];
	solidDec(p, data, dec, x, y, z);
}


void leaves(Packer *p, int x, int y, int z, ubyte, WorkspaceData *data)
{
	auto d = data.getDataUnsafe(x, y, z);
	auto dec = &leavesTile[d & 3];
	solidDec(p, data, dec, x, y, z);
}


void glass(Packer *p, int x, int y, int z, ubyte, WorkspaceData *data)
{
	const type = 20;
	auto dec = &tile[type];
	int set = data.getSolidOrTypeSet(type, x, y, z);

	/* all set */
	if (set == 0)
		return;

	makeXYZ(p, data, dec, x, y, z, set);
}


void dispenser(Packer *p, int x, int y, int z, ubyte, WorkspaceData *data)
{
	auto dec = &tile[23];
	auto decFront = &dispenserFrontTile;
	int set = data.getSolidSet(x, y, z);
	auto d = data.getDataUnsafe(x, y, z);

	auto faceNormal = [sideNormal.ZN, sideNormal.ZP,
	     sideNormal.XN, sideNormal.XP][d-2];

	makeFacedBlock(p, data, dec, decFront, x, y, z, faceNormal, set);
}


void bed(Packer *p, int x, int y, int z, ubyte, WorkspaceData *data)
{
	int set = data.getSolidSet(x, y, z);
	ubyte d = data.getDataUnsafe(x, y, z);
	ubyte tex = 0;

	ubyte direction = d & 3;
	bool cushion = (d & 8) == 8;
	int dec_index = [0, 3][cushion];

	const shift = VERTEX_SIZE_BIT_SHIFT;
	x <<= shift;
	y <<= shift;
	z <<= shift;

	int y1 = y, y2 = y + 8;
	int x1 = x, x2 = x + 16;
	int z1 = z, z2 = z + 16;

	uvManip rotation = [
		uvManip.ROT_90,
		uvManip.ROT_180,
		uvManip.ROT_270,
		uvManip.NONE
	][direction];

	// use wood as bottom texture
	tex = calcTextureY(&tile[5]);
	emitQuadMappedUVYN(p, x1, x2, y1+4, z1, z2, tex, sideNormal.YN, 0, 0, rotation);

	// top
	tex = calcTextureY(&bedTile[dec_index]);
	emitQuadMappedUVYP(p, x1, x2, y2, z1, z2, tex, sideNormal.YP, 0, 0, rotation);

	// draw one side
	dec_index++;
	tex = calcTextureXZ(&bedTile[dec_index]);

	// direction % 2 is the axis the bed is facing (0 is X, 1 is Z)
	x2 = [x1, x2][direction % 2];
	z2 = [z2, z1][direction % 2];
	sideNormal side_normal = [sideNormal.XN, sideNormal.ZN][direction % 2];
	bool flip_tex = direction > 1;

	if (set & (1 << side_normal))
		emitQuadMappedUVXZN(
			p, x1, x2, y1, y2, z1, z2,
			tex, side_normal, 0, -8,
			flip_tex ? uvManip.FLIP_U : uvManip.NONE);

	// draw opposite side
	if (isNormalX(side_normal)) {
		side_normal = sideNormal.XP;
		x1 = x2 += 16;
	} else if (isNormalZ(side_normal)) {
		side_normal = sideNormal.ZP;
		z1 = z2 += 16;
	}

	if (set & (1 << side_normal)) {
		emitQuadMappedUVXZP(
			p, x1, x2, y1, y2, z1, z2,
			tex, side_normal, 0, -8,
			flip_tex ? uvManip.NONE : uvManip.FLIP_U);
	}

	// draw front
	// offset array access by two for cushion part (equals a rotation by 180 degrees)
	auto params = [
		[x,    x+16, z,    z,    sideNormal.ZN],
		[x+16, x+16, z,    z+16, sideNormal.XP],
		[x,    x+16, z+16, z+16, sideNormal.ZP],
		[x,    x,    z,    z+16, sideNormal.XN]
			][(direction + cushion*2) % 4];

	sideNormal front_normal = cast(sideNormal)(params[4]);

	if (set & (1 << front_normal)) {
		dec_index++;
		tex = calcTextureXZ(&bedTile[dec_index]);

		auto emit = [
			&emitQuadMappedUVXZN,
			&emitQuadMappedUVXZP
		][isNormalPositive(front_normal)];

		emit(p, params[0], params[1], y1, y2, params[2], params[3],
		     tex, front_normal, 0, -8, uvManip.NONE);
	}
}


void rails(Packer *p, int x, int y, int z, ubyte type, WorkspaceData *data)
{
	auto d = data.getDataUnsafe(x, y, z);
	int set = data.getSolidSet(x, y, z);
	ubyte tex = 0;
	uvManip manip = uvManip.NONE;

	const shift = VERTEX_SIZE_BIT_SHIFT;
	x <<= shift;
	y <<= shift;
	z <<= shift;

	if (type == 28) {
		// detector rail
		tex = calcTextureY(&railTile[4]);
	} else if (type == 27) {
		// powered rail (on / off)
		tex = calcTextureY(&railTile[(d & 8) ? 3 : 2]);
		d = d & 7;
	} else {
		// regular rail (corner / line)
		tex = calcTextureY(&railTile[(d > 5) ? 0 : 1]);
	}

	if (d < 2 || d > 5) {
		// straight lines or corner pieces
		if (d < 2) {
			manip = (d == 0) ? uvManip.NONE : uvManip.ROT_90;
		} else {
			d -= 6;
			manip = cast(uvManip)([
					uvManip.NONE, uvManip.ROT_90,
					uvManip.ROT_180, uvManip.ROT_270
				][d]);
		}

		emitQuadYP(p, x, x+16, y+1, z, z+16, tex, sideNormal.YP, manip);
		if (set & sideMask.YN)
			emitQuadYN(p, x, x+16, y+1, z, z+16, tex, sideNormal.YN, manip);
	} else {
		// ascending tracks
		d -= 2;
		auto direction = [
			sideNormal.XP, sideNormal.XN,
			sideNormal.ZN, sideNormal.ZP
		][d];

		emitAscendingRailQuadYP(p, x, x+16, y+1, y+17, z, z+16, tex, direction);
		emitAscendingRailQuadYN(p, x, x+16, y+1, y+17, z, z+16, tex, direction);
	}
}


void plants(Packer *p, int x, int y, int z, ubyte type, WorkspaceData *data)
{
	auto dec = &tile[type];
	diagonalSprite(p, x, y, z, dec);
}


void wool(Packer *p, int x, int y, int z, ubyte, WorkspaceData *data)
{
	auto dec = &woolTile[data.getDataUnsafe(x, y, z)];
	solidDec(p, data, dec, x, y, z);
}


void slab(Packer *p, int x, int y, int z, ubyte type, WorkspaceData *data)
{
	int set = data.getSolidOrTypeSet(type, x, y, z);
	auto d = data.getDataUnsafe(x, y, z);

	auto dec = &slabTile[d];

	if (type == 44)
		makeHalfXYZ(p, data, dec, x, y, z, set | sideMask.YP);

	else if (set != 0) /* nothing to do */
		makeXYZ(p, data, dec, x, y, z, set);
}


void torch(Packer *p, int x, int y, int z, ubyte type, WorkspaceData *data)
{
	auto dec = &tile[type];
	ubyte tex = calcTextureXZ(dec);
	auto d = data.getDataUnsafe(x, y, z);

	const shift = VERTEX_SIZE_BIT_SHIFT;
	x <<= shift;
	y <<= shift;
	z <<= shift;

	if (d >= 5)
		return standingTorch(p, x+8, y, z+8, tex);

	d--;

	int bxoff = [-8, +8,  0,  0][d];
	int txoff = bxoff / 4;
	int bzoff = [ 0,  0, -8, +8][d];
	int tzoff = bzoff / 4;

	int x1 = x,   x2 = x+16;
	int y1 = y+3, y2 = y+19;
	int z1 = z+9, z2 = z+7;

	emitTiltedQuadXZN(p, x1+bxoff, x2+bxoff, x1+txoff, x2+txoff, y1, y2,
	                  z2+bzoff, z2+bzoff, z2+tzoff, z2+tzoff, tex, sideNormal.ZN);
	emitTiltedQuadXZP(p, x1+bxoff, x2+bxoff, x1+txoff, x2+txoff, y1, y2,
	                  z1+bzoff, z1+bzoff, z1+tzoff, z1+tzoff, tex, sideNormal.ZP);

	x1 = x+9; x2 = x+7;
	z1 = z;   z2 = z+16;

	emitTiltedQuadXZN(p, x2+bxoff, x2+bxoff, x2+txoff, x2+txoff, y1, y2,
	                  z1+bzoff, z2+bzoff, z1+tzoff, z2+tzoff, tex, sideNormal.XN);
	emitTiltedQuadXZP(p, x1+bxoff, x1+bxoff, x1+txoff, x1+txoff, y1, y2,
	                  z1+bzoff, z2+bzoff, z1+tzoff, z2+tzoff, tex, sideNormal.XP);

	// Use center part of the texture as top.
	int xoff = [-4, +4,  0,  0][d];
	int zoff = [ 0,  0, -4, +4][d];
	int uoff = [+4, -4,  0,  0][d];
	int voff = [-1, -1, +3, -5][d];

	emitQuadMappedUVYP(p, x+7+xoff, x+9+xoff, y+13, z+7+zoff, z+9+zoff,
	                   tex, sideNormal.YP, uoff, voff, uvManip.NONE);
}


void stair(Packer *p, int x, int y, int z, ubyte type, WorkspaceData *data)
{
	auto dec = &tile[type];
	int set = data.getSolidSet(x, y, z);
	auto d = data.getDataUnsafe(x, y, z);
	ubyte tex = calcTextureXZ(dec);

	// Half front
	sideMask frontMask = [sideMask.XN, sideMask.XP, sideMask.ZN, sideMask.ZP][d];
	makeHalfXYZ(p, data, dec, x, y, z, frontMask & set);

	sideMask backMask = [sideMask.XP, sideMask.XN, sideMask.ZP, sideMask.ZN][d];
	makeXYZ(p, data, dec, x, y, z, (backMask | sideMask.YN) & set);

	sideNormal norm1 = [sideNormal.ZN, sideNormal.ZP, sideNormal.XN, sideNormal.XP][d];
	makeStairXZ(p, data, dec, x, y, z, norm1, d == 1 || d == 2);

	sideNormal norm2 = [sideNormal.ZP, sideNormal.ZN, sideNormal.XP, sideNormal.XN][d];
	makeStairXZ(p, data, dec, x, y, z, norm2, d == 1 || d == 2);

	const shift = VERTEX_SIZE_BIT_SHIFT;
	x <<= shift;
	y <<= shift;
	z <<= shift;

	int X1 = x, XM = x + 8, X2 = x + 16;
	int Y1 = y, YM = y + 8, Y2 = y + 16;
	int Z1 = z, ZM = z + 8, Z2 = z + 16;

	// Midfront (top) and back
	sideMask midfront = [sideMask.XN, sideMask.XP, sideMask.ZN, sideMask.ZP][d];

	int x1 = [XM, X1, X1, X1][d];
	int x2 = [X2, XM, X2, X2][d];
	int z1 = [Z1, Z1, ZM, Z1][d];
	int z2 = [Z2, Z2, Z2, ZM][d];
	int ya = [YM, YM, YM, Y1][d];
	int yb = [YM, YM, Y1, YM][d];
	int yc = [YM, Y1, YM, YM][d];
	int yd = [Y1, YM, YM, YM][d];

	if (midfront & sideMask.ZN)
		emitQuadXZN(p, x1, x2, ya, Y2, z1, z1, tex, sideNormal.ZN, uvManip.HALF_V);
	if (midfront & sideMask.ZP)
		emitQuadXZP(p, x1, x2, yb, Y2, z2, z2, tex, sideNormal.ZP, uvManip.HALF_V);
	if (midfront & sideMask.XN)
		emitQuadXZN(p, x1, x1, yc, Y2, z1, z2, tex, sideNormal.XN, uvManip.HALF_V);
	if (midfront & sideMask.XP)
		emitQuadXZP(p, x2, x2, yd, Y2, z1, z2, tex, sideNormal.XP, uvManip.HALF_V);

	// Top
	uvManip manip = [uvManip.HALF_U, uvManip.HALF_U, uvManip.HALF_V, uvManip.HALF_V][d];

	if (set & sideMask.YP)
		emitQuadYP(p, x1, x2, Y2, z1, z2, tex, sideNormal.YP, manip);

	int x3 = [X1, XM, X1, X1][d];
	int x4 = [XM, X2, X2, X2][d];
	int z3 = [Z1, Z1, Z1, ZM][d];
	int z4 = [Z2, Z2, ZM, Z2][d];
	emitQuadYP(p, x3, x4, YM, z3, z4, tex, sideNormal.YP, manip);
}


void chest(Packer *p, int x, int y, int z, ubyte, WorkspaceData *data)
{
	const type = 54;
	auto dec = &chestTile[0];
	int set = data.getSolidSet(x, y, z);

	// Look for adjacent chests.
	ubyte north = data.get(x, y, z-1) == type;
	ubyte south = data.get(x, y, z+1) == type;
	ubyte east = data.get(x-1, y, z) == type;
	ubyte west = data.get(x+1, y, z) == type;

	// No chest around, render a single chest.
	if (!north && !south && !east && !west) {
		auto frontDec = &chestTile[1];
		return makeFacedBlock(p, data, dec, frontDec, x, y, z, sideNormal.ZP, set);
	}

	// Double chest along the z-axis will face west.
	if (north || south) {
		auto front_dec = (north) ? &chestTile[2] : &chestTile[3];
		auto back_dec = (north) ? &chestTile[5] : &chestTile[4];

		if (set & sideMask.ZN)
			makeXZ(p, data, dec, x, y, z, sideNormal.ZN);
		if (set & sideMask.ZP)
			makeXZ(p, data, dec, x, y, z, sideNormal.ZP);
		if (set & sideMask.XN)
			makeXZ(p, data, back_dec, x, y, z, sideNormal.XN);
		if (set & sideMask.XP)
			makeXZ(p, data, front_dec, x, y, z, sideNormal.XP);
		// Double chest along the x-axis will face south.
	} else {
		auto front_dec = (west) ? &chestTile[2] : &chestTile[3];
		auto back_dec = (west) ? &chestTile[5] : &chestTile[4];

		if (set & sideMask.ZN)
			makeXZ(p, data, back_dec, x, y, z, sideNormal.ZN);
		if (set & sideMask.ZP)
			makeXZ(p, data, front_dec, x, y, z, sideNormal.ZP);
		if (set & sideMask.XN)
			makeXZ(p, data, dec, x, y, z, sideNormal.XN);
		if (set & sideMask.XP)
			makeXZ(p, data, dec, x, y, z, sideNormal.XP);
	}

	if (set & sideMask.YN)
		makeY(p, data, dec, x, y, z, sideNormal.YN);
	if (set & sideMask.YP)
		makeY(p, data, dec, x, y, z, sideNormal.YP);
}


void redstoneWire(Packer *p, int x, int y, int z, ubyte, WorkspaceData *data)
{
	bool shouldLinkTo(ubyte type) {
		return type == 55 || type == 75 || type == 76;
	}

	auto d = data.getDataUnsafe(x, y, z);

	// Find all neighbours with either redstone wire or a torch.
	ubyte NORTH = data.get(x, y, z-1), NORTH_DOWN = data.get(x, y-1, z-1), NORTH_UP = data.get(x, y+1, z-1);
	ubyte SOUTH = data.get(x, y, z+1), SOUTH_DOWN = data.get(x, y-1, z+1), SOUTH_UP = data.get(x, y+1, z+1);
	ubyte EAST = data.get(x-1, y, z), EAST_DOWN = data.get(x-1, y-1, z), EAST_UP = data.get(x-1, y+1, z);
	ubyte WEST = data.get(x+1, y, z), WEST_DOWN = data.get(x+1, y-1, z), WEST_UP = data.get(x+1, y+1, z);

	auto north = shouldLinkTo(NORTH) || shouldLinkTo(NORTH_UP) || shouldLinkTo(NORTH_DOWN);
	auto south = shouldLinkTo(SOUTH) || shouldLinkTo(SOUTH_UP) || shouldLinkTo(SOUTH_DOWN);
	auto east = shouldLinkTo(EAST) || shouldLinkTo(EAST_UP) || shouldLinkTo(EAST_DOWN);
	auto west = shouldLinkTo(WEST) || shouldLinkTo(WEST_UP) || shouldLinkTo(WEST_DOWN);

	ubyte connection = north << 0 | south << 1 | east << 2 | west << 3;

	int x1=x, y1=y, z1=z;

	const shift = VERTEX_SIZE_BIT_SHIFT;
	x1 <<= shift;
	y1 <<= shift;
	z1 <<= shift;

	struct WireMapping {
		RedstoneWireType type;
		uvManip manip;
	}

	// For every possible combination of redstone connections, get the needed tile
	// and necessary uv manipulations.
	const WireMapping mappings[] = [
	{RedstoneWireType.Crossover, 	uvManip.NONE},		// A single wire, no connections.
	{RedstoneWireType.Line,		uvManip.ROT_90},	// N
	{RedstoneWireType.Line,		uvManip.ROT_90},	// S
	{RedstoneWireType.Line,		uvManip.ROT_90},	// N+S
	{RedstoneWireType.Line,		uvManip.NONE},		// E
	{RedstoneWireType.Corner,    	uvManip.ROT_90},	// E+N
	{RedstoneWireType.Corner,    	uvManip.NONE},		// E+S
	{RedstoneWireType.Tjunction,   	uvManip.NONE},		// E+N+S
	{RedstoneWireType.Line,		uvManip.NONE},		// W
	{RedstoneWireType.Corner,    	uvManip.ROT_180},	// W+N
	{RedstoneWireType.Corner,    	uvManip.FLIP_U},	// W+S
	{RedstoneWireType.Tjunction,   	uvManip.FLIP_U},	// W+N+S
	{RedstoneWireType.Line,		uvManip.NONE},		// W+E
	{RedstoneWireType.Tjunction,   	uvManip.ROT_90},	// W+E+N
	{RedstoneWireType.Tjunction,   	uvManip.ROT_270},	// W+E+S
	{RedstoneWireType.Crossover,	uvManip.NONE}		// W+E+N+S
	];

	uint active = (d > 0) ? 1 : 0;
	WireMapping tile = mappings[connection];

	// Place wire on the ground.
	ubyte tex = calcTextureXZ(&redstoneWireTile[active][tile.type]);
	emitQuadYP(p, x1, x1+16, y1+1, z1, z1+16, tex, sideNormal.YP, tile.manip);

	// Place wire at the side of a block.
	tex = calcTextureXZ(&redstoneWireTile[active][RedstoneWireType.Line]);

	if (shouldLinkTo(NORTH_UP))
		emitQuadXZP(p, x1, x1+16, y1, y1+16, z1+1, z1+1, tex, sideNormal.ZP, uvManip.ROT_90);
	if (shouldLinkTo(SOUTH_UP))
		emitQuadXZN(p, x1, x1+16, y1, y1+16, z1+15, z1+15, tex, sideNormal.ZN, uvManip.ROT_90);
	if (shouldLinkTo(EAST_UP))
		emitQuadXZP(p, x1+1, x1+1, y1, y1+16, z1, z1+16, tex, sideNormal.XP, uvManip.ROT_90);
	if (shouldLinkTo(WEST_UP))
		emitQuadXZN(p, x1+15, x1+15, y1, y1+16, z1, z1+16, tex, sideNormal.XN, uvManip.ROT_90);
}


void craftingTable(Packer *p, int x, int y, int z, ubyte, WorkspaceData *data)
{
	int set = data.getSolidSet(x, y, z);
	int setAlt = set & (1 << 0 | 1 << 4);
	auto dec = &tile[58];
	auto decAlt = &craftingTableAltTile;

	// Don't emit the same sides
	set &= ~setAlt;

	if (set != 0)
		makeXYZ(p, data, dec, x, y, z, set);

	if (setAlt != 0)
		makeXYZ(p, data, decAlt, x, y, z, setAlt);
}


void crops(Packer *p, int x, int y, int z, ubyte, WorkspaceData *data)
{
	auto dec = &cropsTile[data.getDataUnsafe(x, y, z)];
	ubyte tex = calcTextureXZ(dec);
	const int set = 51;

	const shift = VERTEX_SIZE_BIT_SHIFT;
	x <<= shift;
	y <<= shift;
	z <<= shift;

	// TODO Crops should be offset 1/16 of a block.
	int x1 = x,    x2 = x+16;
	int y1 = y,    y2 = y+16;

	int z1 = z+4;
	emitQuadXZN(p, x1, x2, y1, y2, z1, z1, tex, sideNormal.ZN);
	emitQuadXZP(p, x1, x2, y1, y2, z1, z1, tex, sideNormal.ZP);
	int z2 = z+12;
	emitQuadXZN(p, x1, x2, y1, y2, z2, z2, tex, sideNormal.ZN);
	emitQuadXZP(p, x1, x2, y1, y2, z2, z2, tex, sideNormal.ZP);

	z1 = z; z2 = z+16;

	x1 = x+4;
	emitQuadXZN(p, x1, x1, y1, y2, z1, z2, tex, sideNormal.XN);
	emitQuadXZP(p, x1, x1, y1, y2, z1, z2, tex, sideNormal.XP);

	x2 = x+12;
	emitQuadXZN(p, x2, x2, y1, y2, z1, z2, tex, sideNormal.XN);
	emitQuadXZP(p, x2, x2, y1, y2, z1, z2, tex, sideNormal.XP);
}


void farmland(Packer *p, int x, int y, int z, ubyte, WorkspaceData *data)
{
	auto d = data.getDataUnsafe(x, y, z);
	if (d > 0)
		d = 1;

	auto dec = &farmlandTile[d];
	solidDec(p, data, dec, x, y, z);
}


void furnace(Packer *p, int x, int y, int z, ubyte type, WorkspaceData *data)
{
	auto dec = &tile[type];
	auto decFront = &furnaceFrontTile[type - 61];
	int set = data.getSolidSet(x, y, z);
	auto d = data.getDataUnsafe(x, y, z);

	auto faceNormal = [sideNormal.ZN, sideNormal.ZP,
	     sideNormal.XN, sideNormal.XP][d-2];

	makeFacedBlock(p, data, dec, decFront, x, y, z, faceNormal, set);
}


void signpost(Packer *p, int x, int y, int z, ubyte, WorkspaceData *data)
{
	auto dec = &tile[63];
	int set = data.getSolidSet(x, y, z);
	auto d = data.getDataUnsafe(x, y, z);
	ubyte tex = calcTextureXZ(dec);

	const shift = VERTEX_SIZE_BIT_SHIFT;
	x <<= shift;
	y <<= shift;
	z <<= shift;

	int x1 = x+7, x2 = x+9;
	int z1 = z+7, z2 = z+9;
	int y1 = y, y2 = y+8;

	// Pole
	emitQuadXZN(p, x1, x1, y1, y2, z1, z2, tex, sideNormal.XN);
	emitQuadXZP(p, x2, x2, y1, y2, z1, z2, tex, sideNormal.XP);
	emitQuadXZN(p, x1, x2, y1, y2, z1, z1, tex, sideNormal.ZN);
	emitQuadXZP(p, x1, x2, y1, y2, z2, z2, tex, sideNormal.ZP);

	bool north = [ true,  true, false, false,
	              false, false,  true,  true,
	               true,  true, false, false,
	              false, false,  true,  true][d];

	// Sign
	if (north) {
		// North/South orientation
		z1 = z+7;
		z2 = z+9;
		x1 = x;
		x2 = x+16;
		y1 = y+8;
		y2 = y+16;
	} else {
		// West/East orientation
		x1 = x+7;
		x2 = x+9;
		z1 = z;
		z2 = z+16;
		y1 = y+8;
		y2 = y+16;
	}

	emitQuadXZN(p, x1, x1, y1, y2, z1, z2, tex, sideNormal.XN);
	emitQuadXZP(p, x2, x2, y1, y2, z1, z2, tex, sideNormal.XP);
	emitQuadYN(p, x1, x2, y1, z1, z2, tex, sideNormal.YN);
	emitQuadYP(p, x1, x2, y2, z1, z2, tex, sideNormal.YP);
	emitQuadXZN(p, x1, x2, y1, y2, z1, z1, tex, sideNormal.ZN);
	emitQuadXZP(p, x1, x2, y1, y2, z2, z2, tex, sideNormal.ZP);
}


void door(Packer *p, int x, int y, int z, ubyte type, WorkspaceData *data)
{
	auto dec = &tile[type];
	int set = data.getSolidSet(x, y, z);
	auto d = data.getDataUnsafe(x, y, z);
	ubyte tex;

	if (d & 8)
		// top half
		tex = calcTextureXZ(dec);
	else
		// bottom half
		tex = calcTextureY(dec);

	bool flip = false;
	if (d & 4) {
		d += 1;
		flip = true;
	}

	const shift = VERTEX_SIZE_BIT_SHIFT;
	x <<= shift;
	y <<= shift;
	z <<= shift;

	d &= 3;

	int x1 = [x,    x,    x+13, x   ][d];
	int x2 = [x+3,  x+16, x+16, x+16][d];
	int y1 = y;
	int y2 = y+16;
	int z1 = [z,    z,    z,    z+13][d];
	int z2 = [z+16, z+3,  z+16, z+16][d];

	if (flip) {
		if (set & sideMask.ZN || d == 3)
			emitQuadMappedUVXZN(p, x1, x2, y1, y2, z1, z1, tex, sideNormal.ZN,
			                    0, 0, (d == 1) ? uvManip.FLIP_U : uvManip.NONE);
		if (set & sideMask.ZP || d == 1)
			emitQuadMappedUVXZP(p, x1, x2, y1, y2, z2, z2, tex, sideNormal.ZP,
			                    0, 0, (d == 3) ? uvManip.FLIP_U : uvManip.NONE);
		if (set & sideMask.XN || d == 2)
			emitQuadMappedUVXZN(p, x1, x1, y1, y2, z1, z2, tex, sideNormal.XN,
			                    0, 0, (d == 0) ? uvManip.FLIP_U : uvManip.NONE);
		if (set & sideMask.XP || d == 0)
			emitQuadMappedUVXZP(p, x2, x2, y1, y2, z1, z2, tex, sideNormal.XP,
			                    0, 0, (d == 2) ? uvManip.FLIP_U : uvManip.NONE);
	} else {
		if (set & sideMask.ZN)
			emitQuadMappedUVXZN(p, x1, x2, y1, y2, z1, z1, tex, sideNormal.ZN,
			                    0, 0, (d == 3) ? uvManip.FLIP_U : uvManip.NONE);
		if (set & sideMask.ZP)
			emitQuadMappedUVXZP(p, x1, x2, y1, y2, z2, z2, tex, sideNormal.ZP,
			                    0, 0, (d != 3) ? uvManip.FLIP_U : uvManip.NONE);
		if (set & sideMask.XN)
			emitQuadMappedUVXZN(p, x1, x1, y1, y2, z1, z2, tex, sideNormal.XN,
			                    0, 0, (d == 2) ? uvManip.FLIP_U : uvManip.NONE);
		if (set & sideMask.XP)
			emitQuadMappedUVXZP(p, x2, x2, y1, y2, z1, z2, tex, sideNormal.XP,
			                    0, 0, (d != 2) ? uvManip.FLIP_U : uvManip.NONE);
	}

	tex = calcTextureY(dec);
	if (set & sideMask.YN)
		emitQuadMappedUVYN(p, x1, x2, y1, z1, z2, tex, sideNormal.YN);
	if (set & sideMask.YP)
		emitQuadMappedUVYP(p, x1, x2, y2, z1, z2, tex, sideNormal.YP);
}

void ladder(Packer *p, int x, int y, int z, ubyte type, WorkspaceData *data)
{
	auto dec = &tile[type];
	auto d = data.getDataUnsafe(x, y, z);
	ubyte tex = calcTextureXZ(dec);

	const shift = VERTEX_SIZE_BIT_SHIFT;
	x <<= shift;
	y <<= shift;
	z <<= shift;

	d -= 2;

	int x1 = [x,    x,    x+15, x+1 ][d];
	int x2 = [x+16, x+16, x+15, x+1 ][d];
	int y1 = y;
	int y2 = y+16;
	int z1 = [z+15, z+1,  z,    z   ][d];
	int z2 = [z+15, z+1,  z+16, z+16][d];
	sideNormal normal = [sideNormal.ZN, sideNormal.ZP,
	                     sideNormal.XN, sideNormal.XP][d];
	bool positive = isNormalPositive(normal);

	if (positive)
		emitQuadXZP(p, x1, x2, y1, y2, z1, z2, tex, normal);
	else
		emitQuadXZN(p, x1, x2, y1, y2, z1, z2, tex, normal);
}

void wallsign(Packer *p, int x, int y, int z, ubyte, WorkspaceData *data)
{
	auto dec = &tile[68];
	int set = data.getSolidSet(x, y, z);
	auto d = data.getDataUnsafe(x, y, z);
	ubyte tex = calcTextureXZ(dec);

	d -= 2;

	const shift = VERTEX_SIZE_BIT_SHIFT;
	x <<= shift;
	y <<= shift;
	z <<= shift;

	int x1 = [x,    x,    x+14, x   ][d];
	int x2 = [x+16, x+16, x+16, x+2 ][d];
	int y1 = y+4;
	int y2 = y+12;
	int z1 = [z+14, z,    z,    z   ][d];
	int z2 = [z+16, z+2,  z+16, z+16][d];

	// Signs don't occupy a whole block, so the front face has to be shown, even
	// when a block is in front of it.
	if (set & sideMask.ZN || d == 0)
		emitQuadXZN(p, x1, x2, y1, y2, z1, z1, tex, sideNormal.ZN);
	if (set & sideMask.ZP || d == 1)
		emitQuadXZP(p, x1, x2, y1, y2, z2, z2, tex, sideNormal.ZP);
	if (set & sideMask.XN || d == 2)
		emitQuadXZN(p, x1, x1, y1, y2, z1, z2, tex, sideNormal.XN);
	if (set & sideMask.XP || d == 3)
		emitQuadXZP(p, x2, x2, y1, y2, z1, z2, tex, sideNormal.XP);

	emitQuadYN(p, x1, x2, y1, z1, z2, tex, sideNormal.YN);
	emitQuadYP(p, x1, x2, y2, z1, z2, tex, sideNormal.YP);
}


void pressurePlate(Packer *p, int x, int y, int z, ubyte type, WorkspaceData *data)
{
	auto dec = &tile[type];
	ubyte tex = calcTextureXZ(dec);

	const shift = VERTEX_SIZE_BIT_SHIFT;
	x <<= shift;
	y <<= shift;
	z <<= shift;

	int x1 = x+1, x2 = x+15;
	int z1 = z+1, z2 = z+15;
	int y1 = y, y2 = y+1;

	emitQuadMappedUVXZN(p, x1, x1, y1, y2, z1, z2, tex, sideNormal.XN);
	emitQuadMappedUVXZP(p, x2, x2, y1, y2, z1, z2, tex, sideNormal.XP);
	emitQuadMappedUVXZN(p, x1, x2, y1, y2, z1, z1, tex, sideNormal.ZN);
	emitQuadMappedUVXZP(p, x1, x2, y1, y2, z2, z2, tex, sideNormal.ZP);
	emitQuadMappedUVYP(p, x1, x2, y2, z1, z2, tex, sideNormal.YP);
}


void stoneButton(Packer *p, int x, int y, int z, ubyte, WorkspaceData *data)
{
	auto dec = &tile[77];
	int set = data.getSolidSet(x, y, z);
	auto d = data.getDataUnsafe(x, y, z);
	ubyte tex = calcTextureXZ(dec);

	const shift = VERTEX_SIZE_BIT_SHIFT;
	x <<= shift;
	y <<= shift;
	z <<= shift;

	// Button pressed state.
	int depth = (d & 8) ? 1 : 2;

	d -= 1;
	d &= 3;

	int x1 = [x,       x+16-depth, x+5,     x+5       ][d];
	int x2 = [x+depth, x+16,       x+11,    x+11      ][d];
	int z1 = [z+5,     z+5,        z,       z+16-depth][d];
	int z2 = [z+11,    z+11,       z+depth, z+16      ][d];
	int y1 = y+6;
	int y2 = y+10;

	// Don't render the face where the button is attached to the block.
	if (set & sideMask.ZN || d != 2)
		emitQuadMappedUVXZN(p, x1, x2, y1, y2, z1, z1, tex, sideNormal.ZN);
	if (set & sideMask.ZP || d != 3)
		emitQuadMappedUVXZP(p, x1, x2, y1, y2, z2, z2, tex, sideNormal.ZP);
	if (set & sideMask.XN || d != 0)
		emitQuadMappedUVXZN(p, x1, x1, y1, y2, z1, z2, tex, sideNormal.XN);
	if (set & sideMask.XP || d != 1)
		emitQuadMappedUVXZP(p, x2, x2, y1, y2, z1, z2, tex, sideNormal.XP);

	emitQuadMappedUVYN(p, x1, x2, y1, z1, z2, tex, sideNormal.YN);
	emitQuadMappedUVYP(p, x1, x2, y2, z1, z2, tex, sideNormal.YP);
}


void snow(Packer *p, int x, int y, int z, ubyte, WorkspaceData *data)
{
	const type = 78;
	auto dec = &tile[type];
	int set = data.getSolidOrTypeSet(type, x, y, z);

	/* all set */
	if (set == 0)
		return;

	set |= sideMask.YP;
	makeHalfXYZ(p, data, dec, x, y, z, set, 2);
}


void cactus(Packer *p, int x, int y, int z, ubyte, WorkspaceData *data)
{
	const type = 81;
	auto dec = &tile[type];
	ubyte tex = calcTextureXZ(dec);

	int x2 = x+1;
	int y2 = y+1;
	int z2 = z+1;

	if (!data.filledOrType(type, x, y+1, z))
		makeY(p, data, dec, x, y, z, sideNormal.YP);
	if (!data.filledOrType(type, x, y-1, z)) {
		dec = &cactusBottomTile;
		makeY(p, data, dec, x, y, z, sideNormal.YN);
	}

	const shift = VERTEX_SIZE_BIT_SHIFT;
	x <<= shift;
	x2 <<= shift;
	y <<= shift;
	y2 <<= shift;
	z <<= shift;
	z2 <<= shift;

	emitQuadXZN(p, x, x2, y, y2, z+1, z+1, tex, sideNormal.ZN);
	emitQuadXZP(p, x, x2, y, y2, z+15, z+15, tex, sideNormal.ZP);
	emitQuadXZN(p, x+1, x+1, y, y2, z, z2, tex, sideNormal.XN);
	emitQuadXZP(p, x+15, x+15, y, y2, z, z2, tex, sideNormal.XP);
}

void fence(Packer *p, int x, int y, int z, ubyte, WorkspaceData *data)
{
	const type = 85;
	auto dec = &tile[type];
	int set = data.getSolidSet(x, y, z);
	ubyte tex = calcTextureXZ(dec);

	// Look for nearby fences.
	auto north = data.get(x, y, z-1) == type;
	auto east = data.get(x-1, y, z) == type;

	const shift = VERTEX_SIZE_BIT_SHIFT;
	x <<= shift;
	y <<= shift;
	z <<= shift;

	int x1 = x+6, x2 = x+10;
	int z1 = z+6, z2 = z+10;
	int y1 = y, y2 = y+16;

	// Pole.
	emitQuadMappedUVXZN(p, x1, x1, y1, y2, z1, z2, tex, sideNormal.XN);
	emitQuadMappedUVXZP(p, x2, x2, y1, y2, z1, z2, tex, sideNormal.XP);
	emitQuadMappedUVXZN(p, x1, x2, y1, y2, z1, z1, tex, sideNormal.ZN);
	emitQuadMappedUVXZP(p, x1, x2, y1, y2, z2, z2, tex, sideNormal.ZP);

	if (set & sideMask.YN)
		emitQuadMappedUVYN(p, x1, x2, y1, z1, z2, tex, sideNormal.YN);
	if (set & sideMask.YP)
		emitQuadMappedUVYP(p, x1, x2, y2, z1, z2, tex, sideNormal.YP);

	// Bars in north or east direction.
	if (north) {
		z1 = z-6;
		z2 = z+6;

		emitQuadMappedUVYP(p, x1+1, x2-1, y+15, z1, z2, tex, sideNormal.YP, 0, -8, uvManip.NONE);
		emitQuadMappedUVYN(p, x1+1, x2-1, y+12, z1, z2, tex, sideNormal.YN, 0, -8, uvManip.NONE);
		emitQuadMappedUVXZP(p, x2-1, x2-1, y+12, y+15, z1, z2, tex,sideNormal.XP, -8, 0, uvManip.NONE);
		emitQuadMappedUVXZN(p, x1+1, x1+1, y+12, y+15, z1, z2, tex,sideNormal.XN, 8, 0, uvManip.NONE);

		emitQuadMappedUVYP(p, x1+1, x2-1, y+9, z1, z2, tex, sideNormal.YP, 0, -8, uvManip.NONE);
		emitQuadMappedUVYN(p, x1+1, x2-1, y+6, z1, z2, tex, sideNormal.YN, 0, -8, uvManip.NONE);
		emitQuadMappedUVXZP(p, x2-1, x2-1, y+6, y+9, z1, z2, tex,sideNormal.XP, -8, 0, uvManip.NONE);
		emitQuadMappedUVXZN(p, x1+1, x1+1, y+6, y+9, z1, z2, tex,sideNormal.XN, 8, 0, uvManip.NONE);
	}

	if (east) {
		z1 = z+6,
		   z2 = z+10;
		x1 = x-6;
		x2 = x+6;

		emitQuadMappedUVYP(p, x1, x2, y+15, z1+1, z2-1, tex, sideNormal.YP, -8, 0, uvManip.NONE);
		emitQuadMappedUVYN(p, x1, x2, y+12, z1+1, z2-1, tex, sideNormal.YN, -8, 0, uvManip.NONE);
		emitQuadMappedUVXZP(p, x1, x2, y+12, y+15, z2-1, z2-1, tex, sideNormal.ZP, -8, 0, uvManip.NONE);
		emitQuadMappedUVXZN(p, x1, x2, y+12, y+15, z1+1, z1+1, tex, sideNormal.ZN, 8, 0, uvManip.NONE);

		emitQuadMappedUVYP(p, x1, x2, y+9, z1+1, z2-1, tex, sideNormal.YP, -8, 0, uvManip.NONE);
		emitQuadMappedUVYN(p, x1, x2, y+6, z1+1, z2-1, tex, sideNormal.YN, -8, 0, uvManip.NONE);
		emitQuadMappedUVXZP(p, x1, x2, y+6, y+9, z2-1, z2-1, tex, sideNormal.ZP, -8, 0, uvManip.NONE);
		emitQuadMappedUVXZN(p, x1, x2, y+6, y+9, z1+1, z1+1, tex, sideNormal.ZN, 8,0, uvManip.NONE);
	}
}

void pumpkin(Packer *p, int x, int y, int z, ubyte, WorkspaceData *data)
{
	auto dec = &tile[86];
	auto decFront = &pumpkinFrontTile;
	int set = data.getSolidSet(x, y, z);
	auto d = data.getDataUnsafe(x, y, z);

	auto faceNormal = [sideNormal.ZN, sideNormal.XP,
	     sideNormal.ZP, sideNormal.XN][d];

	makeFacedBlock(p, data, dec, decFront, x, y, z, faceNormal, set);
}

void jack_o_lantern(Packer *p, int x, int y, int z, ubyte, WorkspaceData *data)
{
	auto dec = &tile[91];
	auto decFront = &jackolanternFrontTile;
	int set = data.getSolidSet(x, y, z);
	auto d = data.getDataUnsafe(x, y, z);

	auto faceNormal = [sideNormal.ZN, sideNormal.XP,
	     sideNormal.ZP, sideNormal.XN][d];

	makeFacedBlock(p, data, dec, decFront, x, y, z, faceNormal, set);
}

void cake(Packer *p, int x, int y, int z, ubyte, WorkspaceData *data)
{
	auto dec = &tile[92];
	int set = data.getSolidSet(x, y, z);
	auto d = data.getDataUnsafe(x, y, z);

	const shift = VERTEX_SIZE_BIT_SHIFT;
	x <<= shift;
	y <<= shift;
	z <<= shift;

	ubyte top_tex = calcTextureY(dec);
	ubyte side_tex = calcTextureXZ(dec);
	ubyte tex = 0;

	// How much is missing from the cake.
	int width = 2*d + 1;

	emitQuadMappedUVYP(p, x+width, x+16, y+8, z, z+16, top_tex, sideNormal.YP);

	emitQuadMappedUVXZN(p, x+width, x+16, y, y+8, z+1,  z+1,  side_tex, sideNormal.ZN, 0, -8, uvManip.NONE);
	emitQuadMappedUVXZP(p, x+width, x+16, y, y+8, z+15, z+15, side_tex, sideNormal.ZP, 0, -8, uvManip.NONE);
	emitQuadMappedUVXZP(p, x+15,    x+15, y, y+8, z,    z+16, side_tex, sideNormal.XP, 0, -8, uvManip.NONE);

	// Render side where the cake was/will be cut.
	if (d > 0)
		tex = calcTextureXZ(&cakeTile[0]);
	else
		tex = side_tex;
	emitQuadMappedUVXZN(p, x+width, x+width, y, y+8, z, z+16, tex, sideNormal.XN, 0,-8, uvManip.NONE);

	if (set & sideMask.YN) {
		tex = calcTextureY(&cakeTile[1]);
		emitQuadMappedUVYN(p, x+width, x+16, y, z, z+16, tex, sideNormal.YN);
	}
}

void redstoneRepeater(Packer *p, int x, int y, int z, ubyte type, WorkspaceData *data)
{
	auto dec = &tile[type];
	ubyte tex = calcTextureY(dec);
	auto d = data.getDataUnsafe(x, y, z);
	auto active = (type == 93);

	const shift = VERTEX_SIZE_BIT_SHIFT;
	x <<= shift;
	y <<= shift;
	z <<= shift;

	int y1 = y,   x1 = x,    z1 = z;
	int y2 = y+2, x2 = x+16, z2 = z+16;

	// Sides
	emitQuadMappedUVXZN(p, x1, x2, y1, y2, z1, z1, tex, sideNormal.ZN);
	emitQuadMappedUVXZP(p, x1, x2, y1, y2, z2, z2, tex, sideNormal.ZP);
	emitQuadMappedUVXZN(p, x1, x1, y1, y2, z1, z2, tex, sideNormal.XN);
	emitQuadMappedUVXZP(p, x2, x2, y1, y2, z1, z2, tex, sideNormal.XP);

	// Top
	uvManip manip = [uvManip.NONE, uvManip.ROT_90, uvManip.ROT_180, uvManip.ROT_270][d & 3];
	emitQuadYP(p, x, x+16, y+2, z, z+16, tex, sideNormal.YP, manip);

	// Torches
	dec = &tile[(active) ? 75 : 76];
	tex = calcTextureXZ(dec);

	x1 = [x+8, x+13, x+8,  x+3][d & 3];
	z1 = [z+3, z+8,  z+13, z+8][d & 3];
	standingTorch(p, x1, y-3, z1, tex);

	// Moving torch, delay is position offset in pixels.
	auto delay = (d >> 2) * 2;

	// Offset by +1/-1 to move torch in default position.
	x2 = [x+8,       x+9-delay, x+8,       x+7+delay][d & 3];
	z2 = [z+7+delay, z+8,       z+9-delay, z+8      ][d & 3];
	standingTorch(p, x2, y-3, z2, tex);
}

void trapdoor(Packer *p, int x, int y, int z, ubyte, WorkspaceData *data)
{
	auto dec = &tile[96];
	ubyte tex = calcTextureY(dec);
	int set = data.getSolidSet(x, y, z);
	auto d = data.getDataUnsafe(x, y, z);

	const shift = VERTEX_SIZE_BIT_SHIFT;
	x <<= shift;
	y <<= shift;
	z <<= shift;

	auto closed = !(d & 4);
	d &= 3;

	int y1 = 0, y2 = 0, x1 = 0, x2 = 0, z1 = 0, z2 = 0;

	if (closed) {
		y1 = y;   x1 = x;    z1 = z;
		y2 = y+3; x2 = x+16; z2 = z+16;
	} else {
		x1 = [x,    x,    x+13, x   ][d];
		x2 = [x+16, x+16, x+16, x+3 ][d];
		z1 = [z+13, z,    z,    z   ][d];
		z2 = [z+16, z+3,  z+16, z+16][d];
		y1 = y;
		y2 = y+16;
	}

	if (set & sideMask.ZN)
		emitQuadMappedUVXZN(p, x1, x2, y1, y2, z1, z1, tex, sideNormal.ZN);
	if (set & sideMask.ZP)
		emitQuadMappedUVXZP(p, x1, x2, y1, y2, z2, z2, tex, sideNormal.ZP);
	if (set & sideMask.XN)
		emitQuadMappedUVXZN(p, x1, x1, y1, y2, z1, z2, tex, sideNormal.XN);
	if (set & sideMask.XP)
		emitQuadMappedUVXZP(p, x2, x2, y1, y2, z1, z2, tex, sideNormal.XP);

	if (set & sideMask.YN)
		emitQuadMappedUVYN(p, x1, x2, y1, z1, z2, tex, sideNormal.YN);
	if (set & sideMask.YP || closed)
		emitQuadMappedUVYP(p, x1, x2, y2, z1, z2, tex, sideNormal.YP);
}


/*
 *
 * Main dispatch table.
 *
 */


BuildFunction[256] buildArray = [
	&air,                //   0
	&solid,
	&grass,
	&solid,
	&solid,              //   4 
	&solid,
	&sapling,
	&solid,
	&water,              //   8
	&water,
	&solid,
	&solid,
	&solid,              //  12
	&solid,
	&solid,
	&solid,
	&solid,              //  16
	&wood,
	&leaves,
	&solid,
	&glass,              //  20
	&solid,
	&solid,
	&dispenser,
	&solid,              //  24
	&solid,
	&bed,
	&rails,
	&rails,              //  28 
	&air, // stickyPistonTop
	&plants,
	&plants,
	&plants,             //  32
	&air, // piston
	&air, // pistonTop
	&wool,
	&air, // pistonMoved //  36 
	&plants,
	&plants,
	&plants,
	&plants,             //  40
	&solid,
	&solid,
	&slab,
	&slab,               //  44 
	&solid,
	&solid,
	&solid,
	&solid,              //  48
	&solid,
	&torch,
	&air, // fire
	&solid,              //  52 
	&stair,
	&chest,
	&redstoneWire,
	&solid,              //  56
	&solid,
	&craftingTable,
	&crops,
	&farmland,           //  60 
	&furnace,
	&furnace,
	&signpost,
	&door,               //  64
	&ladder,
	&rails,
	&stair,
	&wallsign,           //  68 
	&air, // lever
	&pressurePlate,
	&door,
	&pressurePlate,      //  72
	&solid,
	&solid,
	&torch,
	&torch,              //  76 
	&stoneButton,
	&snow,
	&solid, // ice
	&solid,              //  80
	&cactus,
	&solid,
	&plants,
	&solid,              //  84 
	&fence,
	&solid,
	&solid,
	&solid,              //  88
	&solid,
	&air, // portal
	&jack_o_lantern,
	&cake,               //  92
	&redstoneRepeater,
	&redstoneRepeater,
	&air,
	&trapdoor,           //  96 
	&air,
	&air,
	&air,
	&air,                // 100
	&air,
	&air,
	&air,
	&air,                // 104 
	&air,
	&air,
	&air,
	&air,                // 108
	&air,
	&air,
	&air,
	&air,                // 112 
	&air,
	&air,
	&air,
	&air,                // 116
	&air,
	&air,
	&air,
	&air,                // 120 
	&air,
	&air,
	&air,
	&air,                // 124
	&air,
	&air,
	&air,
	&air,                // 128
	&air,
	&air,
	&air,
	&air,                //   4 
	&air,
	&air,
	&air,
	&air,                //   8
	&air,
	&air,
	&air,
	&air,                //  12
	&air,
	&air,
	&air,
	&air,                //  16
	&air,
	&air,
	&air,
	&air,                //  20
	&air,
	&air,
	&air,
	&air,                //  24
	&air,
	&air,
	&air,
	&air,                //  28 
	&air,
	&air,
	&air,
	&air,                //  32
	&air,
	&air,
	&air,
	&air,                //  36 
	&air,
	&air,
	&air,
	&air,                //  40
	&air,
	&air,
	&air,
	&air,                //  44 
	&air,
	&air,
	&air,
	&air,                //  48
	&air,
	&air,
	&air,
	&air,                //  52 
	&air,
	&air,
	&air,
	&air,                //  56
	&air,
	&air,
	&air,
	&air,                //  60 
	&air,
	&air,
	&air,
	&air,                //  64
	&air,
	&air,
	&air,
	&air,                //  68 
	&air,
	&air,
	&air,
	&air,                //  72
	&air,
	&air,
	&air,
	&air,                //  76 
	&air,
	&air,
	&air,
	&air,                //  80
	&air,
	&air,
	&air,
	&air,                //  84 
	&air,
	&air,
	&air,
	&air,                //  88
	&air,
	&air,
	&air,
	&air,                //  92
	&air,
	&air,
	&air,
	&air,                //  96 
	&air,
	&air,
	&air,
	&air,                // 100
	&air,
	&air,
	&air,
	&air,                // 104 
	&air,
	&air,
	&air,
	&air,                // 108
	&air,
	&air,
	&air,
	&air,                // 112 
	&air,
	&air,
	&air,
	&air,                // 116
	&air,
	&air,
	&air,
	&air,                // 120 
	&air,
	&air,
	&air,
	&air,                // 124
	&air,
	&air,
	&air,
];
