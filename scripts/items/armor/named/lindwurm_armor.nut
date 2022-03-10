this.lindwurm_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.lindwurm_armor";
		this.m.Description = "Les écailles robustes d\'un féroce Lindwurm cousues ensemble sur une lourde cotte de mailles. Non seulement c\'est un trophée pour un grand chasseur, mais il dévie également les coups les plus féroces, et les écailles chatoyantes restent intactes par le sang corrodé de Lindwurm.";
		this.m.NameList = [
			"Lindwurm Scales",
			"Dragon\'s Hide",
			"Lizard\'s Coat",
			"Lindwurm Harness",
			"Lindwurm Coat",
			"Wurmscales",
			"Coat of the Lindwurm"
		];
		this.m.Variant = 113;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 7500;
		this.m.Condition = 210;
		this.m.ConditionMax = 210;
		this.m.StaminaModifier = -26;
		this.randomizeValues();
	}

	function getTooltip()
	{
		local result = this.armor.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Insensible au sang acide de Lindwurm"
		});
		return result;
	}

	function onEquip()
	{
		this.named_armor.onEquip();
		local c = this.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			this.m.Container.getActor().getFlags().add("body_immune_to_acid");
		}
	}

	function onUnequip()
	{
		local c = this.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull())
		{
			this.m.Container.getActor().getFlags().remove("body_immune_to_acid");
		}

		this.armor.onUnequip();
	}

});

