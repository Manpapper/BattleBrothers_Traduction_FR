this.oath_of_dominion_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {
		applyEffect = true
	},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.oath_of_dominion";
		this.m.Name = "Oath of Dominion";
		this.m.Icon = "ui/traits/trait_icon_79.png";
		this.m.Description = "This character has taken an Oath of Dominion, and is sworn to protect mankind from the savagery of wild beasts.";
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
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] Resolve when fighting Beasts"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] Melee Skill when fighting Beasts"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] Ranged Skill when fighting Beasts"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] Resolve when not fighting Beasts"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] Melee Skill when not fighting Beasts"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] Ranged Skill when not fighting Beasts"
			}
		];
	}

	function onCombatStarted()
	{
		this.m.applyEffect = true;
	}

	function onCombatFinished()
	{
		this.m.applyEffect = false;
	}

	function onUpdate( _properties )
	{
		if (!this.m.applyEffect)
		{
			return;
		}

		if (!this.getContainer().getActor().isPlacedOnMap())
		{
			return;
		}

		if (this.Tactical.Entities.getInstancesNum(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID()) != 0)
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

