this.mask_of_davkul <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.mask_of_davkul";
		this.m.Name = "Aperçu de Davkul";
		this.m.Description = "L\'aperçu de Davkul est un cadeau conféré à l'homme par des pouvoirs anciens et obscurs, un casque fusionné avec la peau et les os humains à travers le plus indicible des rituels. Un aperçu d\'un avenir où l\'homme ne fera qu\'un avec les créations d\'un royaume au-delà. Il ne se brisera jamais, mais continuera à faire repousser sa peau cicatrisée sur place.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.HideCharacterHead = true;
		this.m.HideCorpseHead = true;
		this.m.IsIndestructible = true;
		this.m.Variant = 85;
		this.updateVariant();
		this.m.ImpactSound = [
			"sounds/combat/cleave_hit_hitpoints_01.wav",
			"sounds/combat/cleave_hit_hitpoints_02.wav",
			"sounds/combat/cleave_hit_hitpoints_03.wav"
		];
		this.m.Value = 20000;
		this.m.Condition = 270.0;
		this.m.ConditionMax = 270.0;
		this.m.StaminaModifier = -10;
		this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Legendary;
	}

	function getTooltip()
	{
		local result = this.helmet.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Se régénère de [color=" + this.Const.UI.Color.PositiveValue + "]90[/color] points de durabilité chaque tour."
		});
		return result;
	}

	function onTurnStart()
	{
		this.m.Condition = this.Math.minf(this.m.ConditionMax, this.m.Condition + 90.0);
		this.updateAppearance();
	}

	function onCombatFinished()
	{
		this.m.Condition = this.m.ConditionMax;
		this.updateAppearance();
	}

});

