this.ignite_firelance_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.ignite_firelance";
		this.m.Name = "Enflammer";
		this.m.Description = "Enflamme la mèche de votre lance de feu et libère un torrent de flamme et de fumée sur vos ennemis.";
		this.m.Icon = "skills/active_202.png";
		this.m.IconDisabled = "skills/active_202_sw.png";
		this.m.Overlay = "active_202";
		this.m.SoundOnUse = [
			"sounds/combat/dlc6/fire_lance_01.wav",
			"sounds/combat/dlc6/fire_lance_02.wav",
			"sounds/combat/dlc6/fire_lance_03.wav",
			"sounds/combat/dlc6/fire_lance_04.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/dlc6/fire_hit_01.wav",
			"sounds/combat/dlc6/fire_hit_02.wav",
			"sounds/combat/dlc6/fire_hit_03.wav",
			"sounds/combat/dlc6/fire_hit_04.wav",
			"sounds/combat/dlc6/fire_hit_05.wav",
			"sounds/combat/dlc6/fire_hit_06.wav"
		];
		this.m.SoundOnHitDelay = 0;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.Delay = 500;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsWeaponSkill = true;
		this.m.IsUsingHitchance = true;
		this.m.IsDoingForwardMove = true;
		this.m.IsTargetingActor = false;
		this.m.InjuriesOnBody = this.Const.Injury.BurningBody;
		this.m.InjuriesOnHead = this.Const.Injury.BurningHead;
		this.m.HitChanceBonus = 40;
		this.m.DirectDamageMult = 0.15;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 5;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.MaxRangeBonus = 0;
		this.m.MaxLevelDifference = 4;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = "A [color=" + this.Const.UI.Color.PositiveValue + "]+40%[/color] de chance de toucher"
		});
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Peut toucher jusqu\'à 2 cibles"
		});
		local ammo = this.getAmmo();

		if (ammo > 0)
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/icons/ammo.png",
				text = "A [color=" + this.Const.UI.Color.PositiveValue + "]" + ammo + "[/color] charge restante"
			});
		}
		else
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Plus de charges disponibles[/color]"
			});
		}

		return ret;
	}

	function isUsable()
	{
		return !this.Tactical.isActive() || this.skill.isUsable() && this.getAmmo() > 0;
	}

	function getAmmo()
	{
		local item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

		if (item == null)
		{
			return 0;
		}

		return item.getAmmo();
	}

	function consumeAmmo()
	{
		local item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

		if (item != null)
		{
			item.consumeAmmo();
		}
	}

	function applyEffectToTargets( _tag )
	{
		local user = _tag.User;
		local targets = _tag.Targets;

		foreach( t in targets )
		{
			if (!t.isAlive() || t.isDying())
			{
				continue;
			}

			local success = this.attackEntity(user, t, false);

			if (success && t.isAlive() && !t.isDying() && t.getTile().IsVisibleForPlayer)
			{
				for( local i = 0; i < this.Const.Tactical.BurnParticles.len() - 1; i = ++i )
				{
					local effect = this.Const.Tactical.BurnParticles[i];
					this.Tactical.spawnParticleEffect(false, effect.Brushes, t.getTile(), effect.Delay, effect.Quantity * 0.1, effect.LifeTimeQuantity * 0.1, effect.SpawnRate * 0.1, effect.Stages, this.createVec(0, 0));
				}
			}
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.RangedSkill += 40;
			_properties.DamageRegularMin = 40;
			_properties.DamageRegularMax = 60;
			_properties.DamageArmorMult = 0.9;
		}
	}

	function onTargetSelected( _targetTile )
	{
		this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);
		local ownTile = this.m.Container.getActor().getTile();
		local dir = ownTile.getDirectionTo(_targetTile);

		if (_targetTile.hasNextTile(dir))
		{
			local forwardTile = _targetTile.getNextTile(dir);

			if (this.Math.abs(forwardTile.Level - ownTile.Level) <= 1)
			{
				this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, forwardTile, forwardTile.Pos.X, forwardTile.Pos.Y);
			}
		}
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInCrossbows ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	function onUse( _user, _targetTile )
	{
		local tag = {
			User = _user,
			TargetTile = _targetTile
		};
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 500, this.onDelayedEffect.bindenv(this), tag);
		return true;
	}

	function onDelayedEffect( _tag )
	{
		local user = _tag.User;
		local targetTile = _tag.TargetTile;
		local myTile = user.getTile();
		local dir = myTile.getDirectionTo(targetTile);
		this.consumeAmmo();

		if (myTile.IsVisibleForPlayer)
		{
			if (user.isAlliedWithPlayer())
			{
				for( local i = 0; i < this.Const.Tactical.FireLanceRightParticles.len(); i = ++i )
				{
					local effect = this.Const.Tactical.FireLanceRightParticles[i];
					this.Tactical.spawnParticleEffect(false, effect.Brushes, myTile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 0));
				}
			}
			else
			{
				for( local i = 0; i < this.Const.Tactical.FireLanceLeftParticles.len(); i = ++i )
				{
					local effect = this.Const.Tactical.FireLanceLeftParticles[i];
					this.Tactical.spawnParticleEffect(false, effect.Brushes, myTile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 0));
				}
			}
		}

		local targets = [];

		if (targetTile.IsOccupiedByActor && targetTile.getEntity().isAttackable())
		{
			targets.push(targetTile.getEntity());
		}

		if (targetTile.hasNextTile(dir))
		{
			local nextTile = targetTile.getNextTile(dir);

			if (nextTile.IsOccupiedByActor && nextTile.getEntity().isAttackable() && this.Math.abs(nextTile.Level - myTile.Level) <= 1)
			{
				targets.push(nextTile.getEntity());
			}
		}

		this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], 1.0, user.getPos());
		local tag = {
			User = user,
			Targets = targets
		};
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 200, this.applyEffectToTargets.bindenv(this), tag);
		return true;
	}

});

