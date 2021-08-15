this.cut_throat_injury <- this.inherit("scripts/skills/injury/injury", {
	m = {
		LastRoundApplied = 0
	},
	function create()
	{
		this.injury.create();
		this.m.ID = "injury.cut_throat";
		this.m.Name = "Entaille sur la Jugulaire";
		this.m.Description = "Une entaille sur la jugulaire, conduisant une hémorragie massive et qui mènera à une mort certaine si elle n\'est pas traitée rapidement en dehors du combat. Si vous survivez, il s\'ensuit une constitution sévèrement diminuée à cause de la grosse perte de sang, et laissera une cicatrice menaçante.";
		this.m.KilledString = "Bled to death";
		this.m.Type = this.m.Type | this.Const.SkillType.TemporaryInjury;
		this.m.DropIcon = "injury_icon_30";
		this.m.Icon = "ui/injury/injury_icon_30.png";
		this.m.IconMini = "injury_icon_30_mini";
		this.m.HealingTimeMin = 1;
		this.m.HealingTimeMax = 4;
		this.m.IsShownOnArm = true;
		this.m.IsAlwaysInEffect = true;
	}

	function getTooltip()
	{
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
			}
		];

		if (!this.m.IsShownOutOfCombat)
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/health.png",
				text = "Ce personnage perdra [color=" + this.Const.UI.Color.NegativeValue + "]6[/color] Points de vie à chaque tour en combat"
			});
		}
		else
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/health.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-50%[/color] de Points de vie"
			});
		}

		this.addTooltipHint(ret);
		return ret;
	}

	function applyDamage()
	{
		if (!this.m.IsShownOutOfCombat && this.m.LastRoundApplied != this.Time.getRound())
		{
			this.m.LastRoundApplied = this.Time.getRound();
			this.spawnIcon("status_effect_01", this.getContainer().getActor().getTile());
			local hitInfo = clone this.Const.Tactical.HitInfo;
			hitInfo.DamageRegular = 6;
			hitInfo.DamageDirect = 1.0;
			hitInfo.BodyPart = this.Const.BodyPart.Body;
			hitInfo.BodyDamageMult = 1.0;
			hitInfo.FatalityChanceMult = 0.0;
			this.getContainer().getActor().onDamageReceived(this.getContainer().getActor(), this, hitInfo);
		}
	}

	function onTurnEnd()
	{
		this.applyDamage();
	}

	function onWaitTurn()
	{
		this.applyDamage();
	}

	function onUpdate( _properties )
	{
		this.injury.onUpdate(_properties);

		if (this.m.IsShownOutOfCombat)
		{
			_properties.HitpointsMult *= 0.5;
		}
	}

});

