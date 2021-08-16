this.round_swing <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.round_swing";
		this.m.Name = "Coup Tournoyant";
		this.m.Description = "Coupe tout ce qu\'il y a autour de vous, qu\'ils soient alliés ou ennemis, avec un coup tournoyant insouciant. Pas compliqué à esquiver car il n\'est dirigé à rien en particulier, mais peut être ddévastateur s\'il touche. Faites attention à vos hommes autour à moins que vous souhaitiez diminuer le salaire que vous versez !";
		this.m.KilledString = "Carved up";
		this.m.Icon = "skills/active_48.png";
		this.m.IconDisabled = "skills/active_48_sw.png";
		this.m.Overlay = "active_48";
		this.m.SoundOnUse = [
			"sounds/combat/round_swing_01.wav",
			"sounds/combat/round_swing_02.wav",
			"sounds/combat/round_swing_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/round_swing_hit_01.wav",
			"sounds/combat/round_swing_hit_02.wav",
			"sounds/combat/round_swing_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsAOE = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
		this.m.HitChanceBonus = -15;
		this.m.DirectDamageMult = 0.3;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 35;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 99;
		this.m.ChanceDisembowel = 50;
		this.m.ChanceSmash = 0;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		local hitchanceBonus = this.m.HitChanceBonus;

		if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInAxes)
		{
			hitchanceBonus = hitchanceBonus + 5;
		}

		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "A [color=" + this.Const.UI.Color.NegativeValue + "]" + hitchanceBonus + "%[/color] de chance de toucher"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Peut toucher jusqu\'à 6 cibles"
			}
		]);
		return ret;
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInAxes ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	function onUse( _user, _targetTile )
	{
		local ret = false;
		local ownTile = this.m.Container.getActor().getTile();
		local soundBackup = [];
		this.spawnAttackEffect(ownTile, this.Const.Tactical.AttackEffectThresh);

		for( local i = 5; i >= 0; i = --i )
		{
			if (!ownTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = ownTile.getNextTile(i);

				if (!tile.IsEmpty && tile.getEntity().isAttackable() && this.Math.abs(tile.Level - ownTile.Level) <= 1)
				{
					if (ret && soundBackup.len() == 0)
					{
						soundBackup = this.m.SoundOnHit;
						this.m.SoundOnHit = [];
					}

					ret = this.attackEntity(_user, tile.getEntity()) || ret;

					if (!_user.isAlive() || _user.isDying())
					{
						break;
					}
				}
			}
		}

		if (ret && this.m.SoundOnHit.len() == 0)
		{
			this.m.SoundOnHit = soundBackup;
		}

		return ret;
	}

	function onTargetSelected( _targetTile )
	{
		local ownTile = this.m.Container.getActor().getTile();

		for( local i = 0; i != 6; i = ++i )
		{
			if (!ownTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = ownTile.getNextTile(i);

				if (this.Math.abs(tile.Level - ownTile.Level) <= 1)
				{
					this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);
				}
			}
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInAxes)
			{
				_properties.MeleeSkill -= 10;
			}
			else
			{
				_properties.MeleeSkill -= 15;
			}
		}
	}

});

