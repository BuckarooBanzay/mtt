globals = {
	"mtt",
	"minetest",
	"require", "io"
}

read_globals = {
	-- Stdlib
	string = {fields = {"split", "trim"}},
	table = {fields = {"copy", "getn"}},

	-- Minetest
	"ItemStack",
	"dump", "dump2",
	"VoxelArea", "vector",

	-- deps
	"Promise", "fakelib"
}
