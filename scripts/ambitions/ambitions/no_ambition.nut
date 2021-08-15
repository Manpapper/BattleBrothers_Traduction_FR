this.no_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.none";
		this.m.Duration = 7.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "La compagnie se porte très bien, il faut juste que ça continue !\n(Aucune Ambition)";
		this.m.RewardTooltip = null;
	}

	function getButtonTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "header",
				text = "Aucune Ambition"
			},
			{
				id = 2,
				type = "text",
				text = "Ne choisissez pas d\'ambition pour l\'instant. On vous demandera de choisir à nouveau après trois jours."
			}
		];
		return ret;
	}

});

