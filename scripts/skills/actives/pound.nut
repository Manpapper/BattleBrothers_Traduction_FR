this.pound <- this.inherit("scripts/skills/skill", {
	m = {
		StunChance = 30
	},
	function create()
	{
		this.m.ID = "actives.pound";
		this.m.Name = "Pound";
		this.m.Name = "Frappe";
		this.m.Description = "Frappe la cible au sol avec la chaîne et frappe la tête. Quelque peu imprévisible, mais capable de frapper par-dessus ou autour d'un bouclier avec un peu de chance. Une cible frappée avec assez de force peut être étourdie pendant un tour.";
		this.m.Icon = "skills/active_50.png";
		this.m.IconDisabled = "skills/active_50_sw.png";
		this.m.Overlay = "active_50";
		this.m.SoundOnUse = [
			"sounds/combat/pound_01.wav",
			"sounds/combat/pound_02.wav",
			"sounds/combat/pound_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/pound_hit_01.wav",
			"sounds/combat/pound_hit_02.wav",
			"sounds/combat/pound_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsShieldRelevant = false;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.DirectDamageMult = 0.4;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 66;
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
			text = "Inflige  [color=" + this.Const.UI.Color.DamageValue + "]" + damage_regular_min + "[/color] - [color=" + this.Const.UI.Color.DamageValue + "]" + damage_regular_max + "[/color] de dégâts aux Point de Vie, avec [color=" + this.Const.UI.Color.DamageValue + "]0[/color] - [color=" + this.Const.UI.Color.DamageValue + "]" + damage_direct_max + "[/color] pouvant ignorer l'armure"
		});

		if (damage_Armor_max > 0)
		{
			ret.push({
				id = 5,
				type = "text",
				icon = "ui/icons/armor_damage.png",
				text = "Inflige  [color=" + this.Const.UI.Color.DamageValue + "]" + damage_Armor_min + "[/color] - [color=" + this.Const.UI.Color.DamageValue + "]" + damage_Armor_max + "[/color] de dégâts à l'armure"
			});
		}

		if (p.IsSpecializedInFlails)
		{
			ret.push({
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Les coups à la tête ignorent [color=" + this.Const.UI.Color.PositiveValue + "]20%[/color] d'armure supplémentaire"
			});
		}
		else
		{
			ret.push({
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Les coups à la tête ignorent [color=" + this.Const.UI.Color.PositiveValue + "]10%[/color] d'armure supplémentaire"
			});
		}

		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "A une chance de [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.StunChance + "%[/color] d'étourdir en cas de réussite"
		});
		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Ignore le bonus à la Défense au Corps à Corps accordé par les boucliers"
		});
		return ret;
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInFlails ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	function onUse( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectBash);
		local success = this.attackEntity(_user, _targetTile.getEntity());

		if (!_user.isAlive() || _user.isDying())
		{
			return success;
		}

		if (success && _targetTile.IsOccupiedByActor && this.Math.rand(1, 100) <= this.m.StunChance && !_targetTile.getEntity().getCurrentProperties().IsImmuneToStun && !_targetTile.getEntity().getSkills().hasSkill("effects.stunned"))
		{
			_targetTile.getEntity().getSkills().add(this.new("scripts/skills/effects/stunned_effect"));

			if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " has stunned " + this.Const.UI.getColorizedEntityName(_targetTile.getEntity()) + " for one turn");
			}
		}

		return success;
	}

	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
		if (_skill == this && _hitInfo.BodyPart == this.Const.BodyPart.Head)
		{
			if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInFlails)
			{
				_hitInfo.DamageDirect += 0.2;
			}
			else
			{
				_hitInfo.DamageDirect += 0.1;
			}
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin += 20;
			_properties.DamageRegularMax += 20;
		}
	}

});

