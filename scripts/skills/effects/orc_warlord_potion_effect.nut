this.orc_warlord_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.orc_warlord_potion";
		this.m.Name = "Source de force";
		this.m.Icon = "skills/status_effect_130.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_130";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Le système limbique de ce personnage a été modifié par l\'ajout d\'une substance qui lui permet de supporter plus longtemps une activité anaérobie particulièrement intense. Sa peau vous semble également légèrement plus verte que dans vos souvenirs, mais vous êtes certain qu\'il s\'agit d\'une coïncidence.";
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "L\'utilisation d\'armes d\'orques n\'entraîne plus de coût supplémentaire en fatigue"
			},
			{
				id = 12,
				type = "hint",
				icon = "ui/tooltips/warning.png",
				text = "D\'autres mutations entraîneront une durée de maladie plus longue."
			}
		];
		return ret;
	}

	function onAdded()
	{
		this.getContainer().getActor().getCurrentProperties().IsProficientWithHeavyWeapons = true;
		local equippedItem = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

		if (equippedItem != null)
		{
			this.getContainer().getActor().getItems().unequip(equippedItem);
			this.getContainer().getActor().getItems().equip(equippedItem);
		}

		equippedItem = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);

		if (equippedItem != null)
		{
			this.getContainer().getActor().getItems().unequip(equippedItem);
			this.getContainer().getActor().getItems().equip(equippedItem);
		}
	}

	function onUpdate( _properties )
	{
		_properties.IsProficientWithHeavyWeapons = true;
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isOrcWarlordPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isOrcWarlordPotionAcquired", false);
	}

});

