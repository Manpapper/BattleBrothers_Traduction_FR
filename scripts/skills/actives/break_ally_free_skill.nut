this.break_ally_free_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.break_ally_free";
		this.m.Name = "Libérer un Allié";
		this.m.Description = "Utilisez tout ce qui est à votre disposition pour libérer un allié proche de ce qui les retient sur place. Taillader, couper, écraser ou ronger peu importe du moment que ça fonctionne !";
		this.m.Icon = "skills/active_151.png";
		this.m.IconDisabled = "skills/active_151_sw.png";
		this.m.Overlay = "active_151";
		this.m.SoundOnUse = [];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingHitchance = false;
		this.m.IsHidden = true;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
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
				id = 3,
				type = "text",
				text = this.getCostString()
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "A [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getChance() + "%[/color] chance de réussir en se basant de la Maîtrise de Mêlée, ou plus s\'il y a déjà eu une tentative de libération de l\'allié."
			}
		];
	}

	function getChance()
	{
		return this.Math.min(100, this.getContainer().getActor().getCurrentProperties().getMeleeSkill() - 10);
	}

	function isHidden()
	{
		local actor = this.getContainer().getActor();

		if (this.Tactical.isActive() && actor.isPlacedOnMap())
		{
			local myTile = actor.getTile();

			for( local i = 0; i < 6; i = ++i )
			{
				if (!myTile.hasNextTile(i))
				{
				}
				else
				{
					local tile = myTile.getNextTile(i);

					if (this.Math.abs(tile.Level - myTile.Level) <= 1 && tile.IsOccupiedByActor && tile.getEntity().isAlliedWith(actor))
					{
						local entity = tile.getEntity();

						if (entity.getSkills().hasSkill("effects.net"))
						{
							this.m.Icon = "skills/active_157.png";
							this.m.IconDisabled = "skills/active_157_sw.png";
							return false;
						}

						if (entity.getSkills().hasSkill("effects.web"))
						{
							this.m.Icon = "skills/active_158.png";
							this.m.IconDisabled = "skills/active_158_sw.png";
							return false;
						}

						if (entity.getSkills().hasSkill("effects.rooted"))
						{
							this.m.Icon = "skills/active_159.png";
							this.m.IconDisabled = "skills/active_159_sw.png";
							return false;
						}

						if (entity.getSkills().hasSkill("effects.kraken_ensnare"))
						{
							this.m.Icon = "skills/active_151.png";
							this.m.IconDisabled = "skills/active_151_sw.png";
							return false;
						}

						if (entity.getSkills().hasSkill("effects.serpent_ensnare"))
						{
							this.m.Icon = "skills/active_190.png";
							this.m.IconDisabled = "skills/active_190_sw.png";
							return false;
						}
					}
				}
			}
		}

		return this.skill.isHidden();
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		local target = _targetTile.getEntity();

		if (!this.m.Container.getActor().isAlliedWith(target))
		{
			return false;
		}

		if (target.getSkills().hasSkill("effects.net"))
		{
			return true;
		}

		if (target.getSkills().hasSkill("effects.web"))
		{
			return true;
		}

		if (target.getSkills().hasSkill("effects.rooted"))
		{
			return true;
		}

		if (target.getSkills().hasSkill("effects.kraken_ensnare"))
		{
			return true;
		}

		if (target.getSkills().hasSkill("effects.serpent_ensnare"))
		{
			return true;
		}

		return false;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();

		if (target.getSkills().hasSkill("effects.net"))
		{
			this.spawnIcon("status_effect_99", _targetTile);
		}

		if (target.getSkills().hasSkill("effects.web"))
		{
			this.spawnIcon("status_effect_100", _targetTile);
		}

		if (target.getSkills().hasSkill("effects.rooted"))
		{
			this.spawnIcon("status_effect_101", _targetTile);
		}

		if (target.getSkills().hasSkill("effects.kraken_ensnare"))
		{
			this.spawnIcon("status_effect_96", _targetTile);
		}

		if (target.getSkills().hasSkill("effects.serpent_ensnare"))
		{
			this.spawnIcon("status_effect_114", _targetTile);
		}

		local breakFree = target.getSkills().getSkillByID("actives.break_free");

		if (breakFree != null)
		{
			if (breakFree.m.SoundOnUse.len() != 0)
			{
				this.Sound.play(breakFree.m.SoundOnUse[this.Math.rand(0, breakFree.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill * breakFree.m.SoundVolume, _user.getPos());
			}

			breakFree.setSkillBonus(this.getContainer().getActor().getCurrentProperties().getMeleeSkill());
			breakFree.onUse(target, _targetTile);
		}

		return true;
	}

});

