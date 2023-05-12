this.oath_of_dominion_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {
		ApplyEffect = true
	},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.oath_of_dominion";
		this.m.Name = "Serment de Domination";
		this.m.Icon = "ui/traits/trait_icon_79.png";
		this.m.Description = "Ce personnage a prêté un serment de domination, et a juré de protéger l\'humanité de la sauvagerie des bêtes sauvages.";
		this.m.Order = this.Const.SkillOrder.Trait - 1;
		this.m.Excluded = [];
	}

	function getTooltip()
	{
		return [
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
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] de Détermination en combattant des bêtes"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] de Compétence en Mêlée en combattant des bêtes"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] de Compétence à Distance en combattant des bêtes"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] de Détermination en combattant autre chose que des bêtes"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] de Compétence en Mêlée en combattant autre chose que des bêtes"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] de Compétence à Distance en combattant autre chose que des bêtes"
			}
		];
	}

	function onCombatStarted()
	{
		this.m.ApplyEffect = true;
	}

	function onCombatFinished()
	{
		this.m.ApplyEffect = false;
	}

	function onUpdate( _properties )
	{
		if (!this.m.ApplyEffect)
		{
			return;
		}

		if (!this.getContainer().getActor().isPlacedOnMap())
		{
			return;
		}

		local fightingBeasts = false;
		local enemies = this.Tactical.Entities.getAllHostilesAsArray();

		foreach( enemy in enemies )
		{
			if (this.Const.EntityType.getDefaultFaction(enemy.getType()) == this.Const.FactionType.Beasts || enemy.getType() == this.Const.EntityType.BarbarianUnhold || enemy.getType() == this.Const.EntityType.BarbarianUnholdFrost)
			{
				fightingBeasts = true;
				break;
			}
		}

		if (fightingBeasts)
		{
			_properties.Bravery += 20;
			_properties.MeleeSkill += 10;
			_properties.RangedSkill += 10;
		}
		else
		{
			_properties.Bravery -= 10;
			_properties.MeleeSkill -= 5;
			_properties.RangedSkill -= 5;
		}
	}

});

