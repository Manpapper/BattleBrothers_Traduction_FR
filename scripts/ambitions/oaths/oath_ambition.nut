this.oath_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		OathDuration = 10,
		OathName = "",
		OathBoonText = "",
		OathBurdenText = ""
	},
	function getOathName()
	{
		return this.m.OathName;
	}

	function create()
	{
		this.ambition.create();
		this.m.IsCancelable = false;
		this.m.IsRepeatable = true;
	}

	function getButtonTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.m.OathName
			},
			{
				id = 2,
				type = "text",
				text = this.getTooltipText() + "\n\n"
			}
		];
		ret.push({
			id = 4,
			type = "header",
			text = "Avantage du Serment"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/ambition_tooltip.png",
			text = this.m.OathBoonText
		});
		local reward_tooltip = this.getRewardTooltip();

		if (this.isGrantingRenown())
		{
			ret.push({
				id = 5,
				type = "text",
				icon = "ui/icons/ambition_tooltip.png",
				text = "Votre Renommée augmentera, ce qui implique une rémunération plus élevée pour les contrats et le déblocage potentiel de nouveaux types de contrats." + (reward_tooltip == "" ? "\n\n" : "")
			});
		}

		if (reward_tooltip != "")
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/ambition_tooltip.png",
				text = reward_tooltip + "\n\n"
			});
		}

		ret.push({
			id = 7,
			type = "header",
			text = "Fardeau du Serment"
		});
		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/ambition_tooltip.png",
			text = this.m.OathBurdenText
		});
		return ret;
	}

	function getUIText()
	{
		local timeRemaining = this.m.OathDuration - this.Math.floor((this.Time.getVirtualTimeF() - this.m.StartTime) / this.World.getTime().SecondsPerDay);
		return "Maintenir un " + this.m.OathName + " pendant " + (timeRemaining > 1 ? "encore " + timeRemaining + " jours" : "1 journée");
	}

	function getRenownOnSuccess()
	{
		return this.Const.World.Assets.ReputationOnOathAmbition;
	}

	function onCheckSuccess()
	{
		if ((this.Time.getVirtualTimeF() - this.m.StartTime) / this.World.getTime().SecondsPerDay >= this.m.OathDuration)
		{
			return true;
		}

		return false;
	}

});

