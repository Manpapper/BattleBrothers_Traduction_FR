this.decapitate <- this.inherit("scripts/skills/skill", {
	m = {
		ApplySwordMastery = false
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
		this.m.ID = "actives.decapitate";
		this.m.Name = "Décapiter";
		this.m.Description = "Un coup dévastateur qui vise à décapiter la cible sur place. Fait plus de dégâts aux points de vie si la cible a déjà des blessures. Tuer la cible résultera toujours à la décapiter, si c\'est possible.";
		this.m.Icon = "skills/active_34.png";
		this.m.IconDisabled = "skills/active_34_sw.png";
		this.m.Overlay = "active_34";
		this.m.SoundOnUse = [
			"sounds/combat/cleave_01.wav",
			"sounds/combat/cleave_02.wav",
			"sounds/combat/cleave_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/decapitate_hit_01.wav",
			"sounds/combat/decapitate_hit_02.wav",
			"sounds/combat/decapitate_hit_03.wav"
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
		this.m.DirectDamageMult = 0.25;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 20;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 100;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 0;
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
			text = "Inflige [color=" + this.Const.UI.Color.DamageValue + "]" + damage_regular_min + "[/color] - [color=" + this.Const.UI.Color.DamageValue + "]" + damage_regular_max * 2 + "[/color] de dommages qui dépendent à quel point la cible est déjà blessée, auxquels [color=" + this.Const.UI.Color.DamageValue + "]0[/color] - [color=" + this.Const.UI.Color.DamageValue + "]" + damage_direct_max + "[/color] peuvent ignorer l\'armure"
		});

		if (damage_Armor_max > 0)
		{
			ret.push({
				id = 5,
				type = "text",
				icon = "ui/icons/armor_damage.png",
				text = "Inflige [color=" + this.Const.UI.Color.DamageValue + "]" + damage_Armor_min + "[/color] - [color=" + this.Const.UI.Color.DamageValue + "]" + damage_Armor_max + "[/color] à l\'armure"
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
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSlash);
		return this.attackEntity(_user, _targetTile.getEntity());
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

