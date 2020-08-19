tperma.config = {}

tperma.config.durabilityloss = 1

tperma.config.previewstyle = 1

tperma.config.customcheck = function(ply)
	return true -- change true to anything you want, checked on PlayerSpawn, for custom things like ply:InEvent()
end

tperma.config.categories = {
	{"Knives", Color(0, 195, 165, 10)},
	{"Guns", Color(0, 165, 240, 10)},
}

tperma.config.weapons = {
	["weapon_ak472"] = {
		price = 250000,
		category = "Knives",
	},
}
