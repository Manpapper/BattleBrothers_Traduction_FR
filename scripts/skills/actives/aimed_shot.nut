this.aimed_shot <- this.inherit("scripts/skills/skill", {
	m = {
		AdditionalAccuracy = 0,
		AdditionalHitChance = 0
	},
	function onItemSet()
	{
	}

	function create()
	{
		this.m.ID = "actives.aimed_shot";
		this.m.Name = "Tir Précis";
		this.m.Description = "Un tir précis où vous vous êtes concentré avec l\'intention de bien toucher votre cible même à distance. Ne peut être utilisé si vous êtes attaqué en mêlée.";
		this.m.KilledString = "Abattu";
		this.m.Icon = "skills/active_18.png";
		this.m.IconDisabled = "skills/active_18_sw.png";
		this.m.Overlay = "active_18";
		this.m.SoundOnUse = [
			"sounds/combat/aimed_shot_01.wav",
			"sounds/combat/aimed_shot_02.wav",
			"sounds/combat/aimed_shot_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/arrow_hit_01.wav",
			"sounds/combat/arrow_hit_02.wav",
			"sounds/combat/arrow_hit_03.wav"
		];
		this.m.SoundOnHitShield = [
			"sounds/combat/shield_hit_arrow_01.wav",
			"sounds/combat/shield_hit_arrow_02.wav",
			"sounds/combat/shield_hit_arrow_03.wav"
		];
		this.m.SoundOnMiss = [
			"sounds/combat/arrow_miss_01.wav",
			"sounds/combat/arrow_miss_02.wav",
			"sounds/combat/arrow_miss_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.Delay = 1000;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsWeaponSkill = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = true;
		this.m.IsDoingForwardMove = false;
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
		this.m.DirectDamageMult = 0.4;
		this.m.ActionPointCost = 8;
		this.m.FatigueCost = 25;
		this.m.MinRange = 1;
		this.m.MaxRange = 7;
		this.m.MaxLevelDifference = 4;
		this.m.ProjectileType = this.Const.ProjectileType.Arrow;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "A une distance de tir de [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tuiles sur un terrain plat, plus si vous tirez depuis une hauteur"
			}
		]);

		if (10 + this.m.AdditionalAccuracy >= 0)
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "A [color=" + this.Const.UI.Color.PositiveValue + "]+" + (10 + this.m.AdditionalAccuracy) + "%[/color] de chance de toucher, et [color=" + this.Const.UI.Color.NegativeValue + "]" + (-2 + this.m.AdditionalHitChance) + "%[/color] par tuile de distance"
			});
		}
		else
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "A [color=" + this.Const.UI.Color.NegativeValue + "]" + (10 + this.m.AdditionalAccuracy) + "%[/color] de chance de toucher, et [color=" + this.Const.UI.Color.NegativeValue + "]" + (-2 + this.m.AdditionalHitChance) + "%[/color] par tuile de distance"
			});
		}

		local ammo = this.getAmmo();

		if (ammo > 0)
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/icons/ammo.png",
				text = "Vous avez [color=" + this.Const.UI.Color.PositiveValue + "]" + ammo + "[/color] de flèches restantes"
			});
		}
		else
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Vous avez besoin d\'un carquois non vide équipé[/color]"
			});
		}

		if (this.Tactical.isActive() && this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Ne peut être utilisé car votre personnage est engagé en mêlée[/color]"
			});
		}

		return ret;
	}

	function isUsable()
	{
		return !this.Tactical.isActive() || this.skill.isUsable() && this.getAmmo() > 0 && !this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions());
	}

	function getAmmo()
	{
		local item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Ammo);

		if (item == null)
		{
			return 0;
		}

		if (item.getAmmoType() == this.Const.Items.AmmoType.Arrows)
		{
			return item.getAmmo();
		}
	}

	function consumeAmmo()
	{
		local item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Ammo);

		if (item != null)
		{
			item.consumeAmmo();
		}
	}

	function onAfterUpdate( _properties )
	{
		this.m.MaxRange = this.m.Item.getRangeMax() + (_properties.IsSpecializedInBows ? 1 : 0);
		this.m.AdditionalAccuracy = this.m.Item.getAdditionalAccuracy();
		this.m.FatigueCostMult = _properties.IsSpecializedInBows ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	function onUse( _user, _targetTile )
	{
		this.consumeAmmo();

		if (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer)
		{
			this.getContainer().setBusy(true);
			local tag = {
				Skill = this,
				User = _user,
				TargetTile = _targetTile
			};
			this.Time.scheduleEvent(this.TimeUnit.Virtual, this.m.Delay, this.onPerformAttack, tag);

			if (!_user.isPlayerControlled() && _targetTile.getEntity().isPlayerControlled())
			{
				_user.getTile().addVisibilityForFaction(this.Const.Faction.Player);
			}

			return true;
		}
		else
		{
			return this.attackEntity(_user, _targetTile.getEntity());
		}
	}

	function onPerformAttack( _tag )
	{
		_tag.Skill.getContainer().setBusy(false);
		return _tag.Skill.attackEntity(_tag.User, _tag.TargetTile.getEntity());
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.RangedSkill += 10 + this.m.AdditionalAccuracy;
			_properties.HitChanceAdditionalWithEachTile += -2 + this.m.AdditionalHitChance;
			_properties.DamageRegularMult *= 1.1;
		}
	}

});

