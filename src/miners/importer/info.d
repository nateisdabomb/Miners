// Copyright © 2011, Jakob Bornecrantz.  All rights reserved.
// See copyright notice in src/charge/charge.d (GPLv2 only).
module miners.importer.info;

import stdx.string : toString;
import std.file : exists, dirEntries, DirEntry, SpanMode;
import std.string : format;

import charge.util.vector;
import charge.math.point3d;

import miners.importer.folders;

import lib.nbt.nbt;


/**
 * Holds information about a single minecraft level.
 */
struct MinecraftLevelInfo
{
	string name;   /**< Level name */
	string dir;    /**< Directory holding this level */
	bool beta;     /**< Is this level a beta level */
	bool nether;   /**< Does this level have a nether directory */
	Point3d spawn; /**< Spawn point */
}

/**
 * Checks a Minecraft level.
 *
 * Returns null if no level.dat was found inside the directory.
 */
MinecraftLevelInfo* checkMinecraftLevel(string level)
{
	auto region = format(level, "/region");
	auto nether = format(level, "/DIM-1");
	string name;
	Point3d spawn;

	if (!getInfoFromLevelDat(level, name, spawn))
		return null;

	auto li = new MinecraftLevelInfo();

	li.name = name;
	li.dir = level;
	li.spawn = spawn;

	if (exists(region))
		li.beta = true;

	if (exists(nether))
		li.nether = true;

	return li;
}

/**
 * Scan a directory for Minecraft worlds.
 *
 * If null or no argument given scans the guesstimated Minecraft save folder.
 *
 * Returns a array of MinecraftLevelInfo's.
 */
MinecraftLevelInfo[] scanForLevels(string dir = null)
{
	VectorData!(MinecraftLevelInfo) levels;

	// If no directory given guesstimate the Minecraft save folder.
	if (dir is null)
		dir = getMinecraftSaveFolder();

	try {
		// Called for each file/directory found in directory
		foreach (DirEntry de; dirEntries(dir, SpanMode.shallow)) {
			// Early out any files that are in the save directory
			if (!de.isDir)
				continue;

			// Check if the level is okay
			auto li = checkMinecraftLevel(de.name);
			if (li is null)
				continue;

			levels ~= *li;
		}
	} catch (Exception e) {
		return null;
	}

	return levels.adup;
}

/**
 * Gets information from a level.dat.
 */
private bool getInfoFromLevelDat(string level, out string name, out Point3d spawn)
{
	auto dat = format(level, "/level.dat\0");
	nbt_node *data;
	nbt_node *levelName;
	nbt_node *spwn;

	auto file = nbt_parse_path(dat.ptr);
	if (!file)
		return false;
	scope(exit)
		nbt_free(file);

	data = nbt_find_by_name(file, "Data");
	if (!data)
		return false;

	levelName = nbt_find_by_name(data, "LevelName");
	if (levelName && levelName.type == TAG_STRING)
		name = toString(levelName.tag_string).idup; // Need to dup

	spawn = Point3d(0, 64, 0);
	foreach(int i, n; ["SpawnX", "SpawnY", "SpawnZ"]) {
		spwn = nbt_find_by_name(data, n.ptr);
		if (!spwn || spwn.type != TAG_INT)
			continue;

		(&spawn.x)[i] = spwn.tag_int;
	}

	return true;
}
