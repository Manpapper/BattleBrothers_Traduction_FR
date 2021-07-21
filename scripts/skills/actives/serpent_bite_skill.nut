this.serpent_bite_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.serpent_bite";
		this.m.Name = "Serpent Bite";
		this.m.Description = "";
		this.m.KilledString = "Bitten to bits";
		this.m.Icon = "skills/active_196.png";
		this.m.Overlay = "active_196";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc6/snake_attack_01.wav",
			"sounds/enemies/dlc6/snake_attack_02.wav",
			"sounds/enemies/dlc6/snake_attack_03.wav",
			"sounds/enemies/dlc6/snake_attack_04.wav"
		];
		this.m.SoundOnHit = [
			"sounds/enemies/dlc6/snake_attack_hit_01.wav",
			"sounds/enemies/dlc6/snake_attack_hit_02.wav",
			"sounds/enemies/dlc6/snake_attack_hit_03.wav",
			"sounds/enemies/dlc6/snake_attack_hit_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.Delay = 500;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
		this.m.DirectDamageMult = 0.3;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 5;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 0;
	}

	function onUpdate( _properties )
	{
		_properties.DamageRegularMin += 50;
		_properties.DamageRegularMax += 70;
		_properties.DamageArmorMult *= 0.75;
	}

	function onUse( _user, _targetTile )
	{
		local tag = {
			Skill = this,
			User = _user,
			TargetTile = _targetTile
		};

		if ((!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer) && this.Tactical.TurnSequenceBar.getActiveEntity().getID() == this.getContainer().getActor().getID())
		{
			this.getContainer().setBusy(true);
			local d = _user.getTile().getDirectionTo(_targetTile) + 3;
			d = d > 5 ? d - 6 : d;

			if (_user.getTile().hasNextTile(d))
			{
				this.Tactical.getShaker().shake(_user, _user.getTile().getNextTile(d), 6);
			}

			this.Time.scheduleEvent(this.TimeUnit.Virtual, 500, this.onPerformAttack.bindenv(this), tag);
			return true;
		}
		else
		{
			return this.attackEntity(_user, _targetTile.getEntity());
		}
	}

	function onPerformAttack( _tag )
	{
		this.attackEntity(_tag.User, _tag.TargetTile.getEntity());
		_tag.Skill.getContainer().setBusy(false);
	}

});

