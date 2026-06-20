this.serpent_ensnare_effect <- this.inherit("scripts/skills/skill", {
	m = {
		LastRoundApplied = 0,
		SpriteScaleBackup = 1.0,
		OnRemoveCallback = null,
		OnRemoveCallbackData = null
	},
	function setOnRemoveCallback( _c, _d )
	{
		this.m.OnRemoveCallback = _c;
		this.m.OnRemoveCallbackData = _d;
	}

	function create()
	{
		this.m.ID = "effects.serpent_ensnare";
		this.m.Name = "Enchevêtrés";
		this.m.Description = "Ce personnage est pris au piège dans un serpent géant. À chaque tour, le serpent menace de l\'écraser en resserrant son étreinte, ce qui entraîne la perte de [color=" + this.Const.UI.Color.NegativeValue + "]10[/color] Points de vie.";
		this.m.Icon = "skills/status_effect_113.png";
		this.m.IconMini = "status_effect_113_mini";
		this.m.Overlay = "status_effect_113";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc6/snake_choke_01.wav",
			"sounds/enemies/dlc6/snake_choke_02.wav",
			"sounds/enemies/dlc6/snake_choke_03.wav",
			"sounds/enemies/dlc6/snake_choke_04.wav",
			"sounds/enemies/dlc6/snake_choke_05.wav"
		];
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
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
				icon = "ui/icons/action_points.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Impossible de bouger[/color]"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Impossible d\'utiliser les compétences[/color]"
			}
		];
	}

	function applyDamage()
	{
		if (this.m.LastRoundApplied != this.Time.getRound())
		{
			this.m.LastRoundApplied = this.Time.getRound();
			this.spawnIcon("status_effect_113", this.getContainer().getActor().getTile());

			if (this.m.SoundOnUse.len() != 0)
			{
				this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect * 1.0, this.getContainer().getActor().getPos());
			}

			local hitInfo = clone this.Const.Tactical.HitInfo;
			hitInfo.DamageRegular = this.Math.rand(10, 15);
			hitInfo.DamageDirect = 1.0;
			hitInfo.BodyPart = this.Const.BodyPart.Body;
			hitInfo.BodyDamageMult = 1.0;
			hitInfo.FatalityChanceMult = 0.0;
			this.getContainer().getActor().onDamageReceived(this.getContainer().getActor(), this, hitInfo);
		}
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		local sprite1 = actor.getSprite("status_rooted");
		local sprite2 = actor.getSprite("status_rooted_back");
		this.m.SpriteScaleBackup = sprite1.Scale;
		sprite1.Scale = 1.0;
		sprite2.Scale = 1.0;
		this.Tactical.TurnSequenceBar.pushEntityBack(this.getContainer().getActor().getID());
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();
		actor.getSprite("status_rooted").Scale = this.m.SpriteScaleBackup;
		actor.getSprite("status_rooted_back").Scale = this.m.SpriteScaleBackup;

		if (this.m.OnRemoveCallback != null && !this.Tactical.Entities.isCombatFinished())
		{
			this.m.OnRemoveCallback(this.m.OnRemoveCallbackData);
		}
	}

	function onDeath( _fatalityType )
	{
		if (this.m.OnRemoveCallbackData != null)
		{
			this.m.OnRemoveCallbackData.LoseHitpoints = false;
		}

		this.onRemoved();
	}

	function onUpdate( _properties )
	{
		_properties.IsRooted = true;
		_properties.IsAbleToUseSkills = false;
		_properties.InitiativeForTurnOrderAdditional = -100;
	}

	function onTurnEnd()
	{
		this.applyDamage();
	}

	function onWaitTurn()
	{
		this.applyDamage();
	}

});

