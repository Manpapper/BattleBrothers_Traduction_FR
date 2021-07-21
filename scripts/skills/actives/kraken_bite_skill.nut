this.kraken_bite_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.kraken_bite";
		this.m.Name = "Morsure";
		this.m.Description = "";
		this.m.KilledString = "Mangled";
		this.m.Icon = "skills/active_146.png";
		this.m.Overlay = "active_146";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/tentacle_bite_01.wav",
			"sounds/enemies/dlc2/tentacle_bite_02.wav",
			"sounds/enemies/dlc2/tentacle_bite_03.wav",
			"sounds/enemies/dlc2/tentacle_bite_04.wav",
			"sounds/enemies/dlc2/tentacle_bite_05.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
		this.m.DirectDamageMult = 0.5;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 50;
		this.m.ChanceSmash = 0;
	}

	function isUsable()
	{
		return this.skill.isUsable() && this.getContainer().getActor().getMode() != 0;
	}

	function onUpdate( _properties )
	{
		_properties.DamageRegularMin += 70;
		_properties.DamageRegularMax += 110;
		_properties.DamageArmorMult *= 1.0;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		local hp = target.getHitpoints();
		local success = this.attackEntity(_user, _targetTile.getEntity());

		if (!_user.isAlive() || _user.isDying())
		{
			return success;
		}

		if (success && target.isAlive() && !target.isDying())
		{
			if (!target.getCurrentProperties().IsImmuneToBleeding && hp - target.getHitpoints() >= this.Const.Combat.MinDamageToApplyBleeding)
			{
				target.getSkills().add(this.new("scripts/skills/effects/bleeding_effect"));
			}
		}

		return success;
	}

});

