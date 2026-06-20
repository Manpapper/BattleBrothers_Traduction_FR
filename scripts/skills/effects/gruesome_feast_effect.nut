this.gruesome_feast_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.gruesome_feast";
		this.m.Name = "Repu";
		this.m.Icon = "skills/status_effect_10.png";
		this.m.IconMini = "status_effect_10_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
	}

	function addFeastStack()
	{
		local actor = this.getContainer().getActor();
		actor.grow();
		actor.checkMorale(1, 20);
	}

	function onUpdate( _properties )
	{
		local size = this.getContainer().getActor().getSize();
		this.m.IsHidden = size <= 1;

		if (size == 2)
		{
			_properties.Hitpoints += 120;
			_properties.MeleeSkill += 10;
			_properties.MeleeDefense += 5;
			_properties.RangedDefense -= 5;
			_properties.Bravery += 30;
			_properties.DamageRegularMin += 15;
			_properties.DamageRegularMax += 20;
			_properties.Initiative -= 15;
		}
		else if (size == 3)
		{
			_properties.Hitpoints += 300;
			_properties.MeleeSkill += 20;
			_properties.MeleeDefense += 10;
			_properties.RangedDefense -= 10;
			_properties.Bravery += 60;
			_properties.DamageRegularMin += 30;
			_properties.DamageRegularMax += 40;
			_properties.Initiative -= 30;
			this.getContainer().getActor().getAIAgent().getProperties().BehaviorMult[this.Const.AI.Behavior.ID.Retreat] = 0.0;
		}
	}

});

