this.nightmare_effect <- this.inherit("scripts/skills/skill", {
	m = {
		LastRoundApplied = 0
	},
	function create()
	{
		this.m.ID = "effects.nightmare";
		this.m.Name = "Cauchemars";
		this.m.KilledString = "Died in his sleep";
		this.m.Icon = "skills/status_effect_81.png";
		this.m.IconMini = "status_effect_81_mini";
		this.m.Overlay = "status_effect_81";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/nightmare_01.wav",
			"sounds/enemies/dlc2/nightmare_02.wav",
			"sounds/enemies/dlc2/nightmare_03.wav",
			"sounds/enemies/dlc2/nightmare_04.wav",
			"sounds/enemies/dlc2/nightmare_05.wav",
			"sounds/enemies/dlc2/nightmare_06.wav",
			"sounds/enemies/dlc2/nightmare_07.wav",
			"sounds/enemies/dlc2/nightmare_08.wav"
		];
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Ce personnage est en proie à des cauchemars surnaturels et se trouve incapable d\'agir. Alors que ces horreurs rongeent peu à peu sa raison, il prendra [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getDamage() + "[/color] de Dégâts basé sur sa Détermination chaque tour. Le personnage peut être réveillé de force par un allié se trouvant à proximité, mais il ne se réveillera pas de lui-même.";
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
				id = 9,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-300[/color] d\'Initiative"
			}
		];
	}

	function getDamage()
	{
		return this.Math.max(10, 30 - this.Math.floor(this.getContainer().getActor().getCurrentProperties().getBravery() * 0.25));
	}

	function applyDamage()
	{
		if (this.m.LastRoundApplied != this.Time.getRound())
		{
			this.m.LastRoundApplied = this.Time.getRound();
			this.spawnIcon("status_effect_81", this.getContainer().getActor().getTile());
			local hitInfo = clone this.Const.Tactical.HitInfo;
			hitInfo.DamageRegular = this.getDamage();
			hitInfo.DamageDirect = 1.0;
			hitInfo.BodyPart = this.Const.BodyPart.Body;
			hitInfo.BodyDamageMult = 1.0;
			hitInfo.FatalityChanceMult = 0.0;
			this.getContainer().getActor().onDamageReceived(this.getContainer().getActor(), this, hitInfo);
		}
	}

	function onAdded()
	{
		this.m.Container.removeByID("effects.shieldwall");
		this.m.Container.removeByID("effects.spearwall");
		this.m.Container.removeByID("effects.riposte");
		this.m.Container.removeByID("effects.return_favor");
		local actor = this.getContainer().getActor();
		actor.getFlags().set("Nightmare", true);

		if (this.m.SoundOnUse.len() != 0)
		{
			this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect * 1.0, this.getContainer().getActor().getPos());
		}
	}

	function onTurnStart()
	{
		local actor = this.getContainer().getActor();
		actor.setActionPoints(0);

		if (this.m.SoundOnUse.len() != 0)
		{
			this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect * 1.0, this.getContainer().getActor().getPos());
		}
	}

	function onResumeTurn()
	{
		this.onTurnStart();
	}

	function onTurnEnd()
	{
		this.applyDamage();
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();

		if (actor.hasSprite("status_stunned"))
		{
			actor.getSprite("status_stunned").Visible = false;
		}

		if (actor.hasSprite("closed_eyes"))
		{
			actor.getSprite("closed_eyes").Visible = false;
		}

		actor.getFlags().set("Nightmare", false);

		if ("setEyesClosed" in actor.get())
		{
			actor.setEyesClosed(false);
		}

		actor.setDirty(true);
		local alps;

		if (this.Tactical.State.isScenarioMode())
		{
			alps = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Beasts);
		}
		else
		{
			alps = this.Tactical.Entities.getInstancesOfFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
		}

		foreach( a in alps )
		{
			if (a.getType() == this.Const.EntityType.Alp)
			{
				a.getSkills().update();
			}
		}
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		_properties.IsStunned = true;
		_properties.Initiative -= 300;

		if (actor.hasSprite("status_stunned"))
		{
			actor.getSprite("status_stunned").setBrush("bust_nightmare");
			actor.getSprite("status_stunned").Visible = true;

			if (actor.hasSprite("closed_eyes"))
			{
				actor.getSprite("closed_eyes").Visible = true;
			}

			if ("setEyesClosed" in actor.get())
			{
				actor.setEyesClosed(true);
			}

			actor.setDirty(true);
		}
	}

});

