this.exesword_decapitate <- this.inherit("scripts/skills/skill", {
	m = {
		ApplySwordMastery = true,
		DecapSound = [
			"sounds/combat/decapitate_hit_01.wav",
			"sounds/combat/decapitate_hit_02.wav",
			"sounds/combat/decapitate_hit_03.wav"
		]
	},
	function isSwordMasteryApplied()
	{
		return this.m.ApplySwordMastery;
	}

	function setApplySwordMastery( _f )
	{
		this.m.ApplySwordMastery = _f;
	}

	function create()
	{
		this.m.ID = "actives.exesword_decapitate";
		this.m.Name = "Décapiter";
		this.m.Description = "Un coup dévastateur visant à décapiter la cible sur place.Plus la cible est blessée, plus elle subit de dégâts. Si la cible est tuée, elle sera toujours décapitée, dans la mesure du possible.";
		this.m.Icon = "skills/active_34.png";
		this.m.IconDisabled = "skills/active_34_sw.png";
		this.m.Overlay = "active_34";
		this.m.SoundOnUse = [
			"sounds/combat/split_01.wav",
			"sounds/combat/split_02.wav",
			"sounds/combat/split_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/overhead_strike_hit_01.wav",
			"sounds/combat/overhead_strike_hit_02.wav",
			"sounds/combat/overhead_strike_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
		this.m.DirectDamageMult = 0.35;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 20;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 100;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 0;
	}

	function addResources()
	{
		this.skill.addResources();

		foreach( r in this.m.DecapSound )
		{
			this.Tactical.addResource(r);
		}
	}

	function getTooltip()
	{
		local p = this.getContainer().buildPropertiesForUse(this, null);
		local damage_regular_min = this.Math.floor(p.DamageRegularMin * p.DamageRegularMult * p.DamageTotalMult * p.MeleeDamageMult);
		local damage_regular_max = this.Math.floor(p.DamageRegularMax * p.DamageRegularMult * p.DamageTotalMult * p.MeleeDamageMult);
		local damage_Armor_min = this.Math.floor(p.DamageRegularMin * p.DamageArmorMult * p.DamageTotalMult * p.MeleeDamageMult);
		local damage_Armor_max = this.Math.floor(p.DamageRegularMax * p.DamageArmorMult * p.DamageTotalMult * p.MeleeDamageMult);
		local damage_direct_max = this.Math.floor(damage_regular_max * (this.m.DirectDamageMult + p.DamageDirectAdd + p.DamageDirectMeleeAdd));
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
				id = 3,
				type = "text",
				text = this.getCostString()
			}
		];
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/regular_damage.png",
			text = "Inflige [color=" + this.Const.UI.Color.DamageValue + "]" + damage_regular_min + "[/color] - [color=" + this.Const.UI.Color.DamageValue + "]" + damage_regular_max * 2 + "[/color] de dégâts proportionnellement aux blessures de la cible, desquelles [color=" + this.Const.UI.Color.DamageValue + "]0[/color] - [color=" + this.Const.UI.Color.DamageValue + "]" + damage_direct_max + "[/color] peuvent ignorer l\'armure"
		});

		if (damage_Armor_max > 0)
		{
			ret.push({
				id = 5,
				type = "text",
				icon = "ui/icons/armor_damage.png",
				text = "Inflige [color=" + this.Const.UI.Color.DamageValue + "]" + damage_Armor_min + "[/color] - [color=" + this.Const.UI.Color.DamageValue + "]" + damage_Armor_max + "[/color] de dégâts d\'armure"
			});
		}

		return ret;
	}

	function onAfterUpdate( _properties )
	{
		if (this.m.ApplySwordMastery)
		{
			this.m.FatigueCostMult = _properties.IsSpecializedInSwords ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
		}
		else
		{
			this.m.FatigueCostMult = _properties.IsSpecializedInCleavers ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
		}
	}

	function onUse( _user, _targetTile )
	{
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 100, function ( _skill )
		{
			if (_targetTile.getEntity().isAlive() && _skill.getContainer() != null)
			{
				_skill.getContainer().setBusy(false);
				_skill.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSlash);
				local success = _skill.attackEntity(_user, _targetTile.getEntity());

				if (success)
				{
					this.Sound.play(_skill.m.DecapSound[this.Math.rand(0, _skill.m.DecapSound.len() - 1)], this.Const.Sound.Volume.Skill, _user.getPos());
				}
			}
		}, this);
		return true;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_targetEntity == null)
		{
			return;
		}

		if (_skill == this)
		{
			_properties.DamageRegularMult += 1.0 - _targetEntity.getHitpoints() / (_targetEntity.getHitpointsMax() * 1.0);
		}
	}

});

