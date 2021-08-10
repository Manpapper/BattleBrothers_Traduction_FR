this.no_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.none";
		this.m.Duration = 7.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "The company is doing great, we just need to keep it up!\n(No Ambition)";
		this.m.RewardTooltip = null;
	}

	function getButtonTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "header",
				text = "No Ambition"
			},
			{
				id = 2,
				type = "text",
				text = "Don\'t choose an ambition right now. You\'ll be asked to choose again after three days."
			}
		];
		return ret;
	}

});

