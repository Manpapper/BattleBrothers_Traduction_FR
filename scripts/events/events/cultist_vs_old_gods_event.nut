this.cultist_vs_old_gods_event <- this.inherit("scripts/events/event", {
	m = {
		Cultist = null,
		OldGods = null
	},
	function create()
	{
		this.m.ID = "event.cultist_vs_old_gods";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_06.png[/img]While enjoying a slice of bacon, you hear wind of a quarrel going on. You ignore it for a time, but the shouts only get louder, quickly rising over your ability to enjoy a good meal. Angered, you stand up and head toward the disturbance. You find %cultist% and %oldgods% facing off, the cultist and follower of the gods having apparently discovered some differences.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s get godly with the goriest!",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Stop this nonsense.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.OldGods.getImagePath());
				this.Characters.push(_event.m.Cultist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_06.png[/img] You step off to the side, letting the men hash out their differences as men with great differences do. Fists for arguments, the follower of the old gods makes his case, battering the cultist again and again. But the man with the scarred head only grins in return. His eyes are puffing up, the lids purpled and puckering over his eyesight. Yet, still, he grins, and there is bloody laughter spewing out of his reddened mouth.%SPEECH_ON%Such darkness! Davkul is most pleased!%SPEECH_OFF%With an anxious look, %oldgods% steps off %cultist% and backs away. He\'s rubbing his bloodied knuckles, realizing he may have broken a few in the seemingly one-sided scuffle. But it\'s the cultist\'s words that hurt him most of all.%SPEECH_ON%Man isn\'t tempted by the darkness, he is called to it! Lost without it! Gleeful in its return!%SPEECH_OFF%Almost afraid to look back, %oldgods% hurries away as the cultist remains behind, laughing and chuckling on the grass, nobody daring to get near him.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I didn\'t know %oldgods% had it in him.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.OldGods.getImagePath());
				this.Characters.push(_event.m.Cultist.getImagePath());
				_event.m.OldGods.worsenMood(1.0, "Lost composure and resorted to violence");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.OldGods.getMoodState()],
					text = _event.m.OldGods.getName() + this.Const.MoodStateEvent[_event.m.OldGods.getMoodState()]
				});
				_event.m.OldGods.getBaseProperties().Bravery += -1;
				_event.m.OldGods.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.OldGods.getName() + " loses [color=" + this.Const.UI.Color.NegativeEventValue + "]-1[/color] Détermination"
				});
				local injury = _event.m.Cultist.addInjury(this.Const.Injury.Brawl);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Cultist.getName() + " suffers " + injury.getNameOnly()
				});
				_event.m.Cultist.getBaseProperties().Bravery += 2;
				_event.m.Cultist.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Cultist.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Détermination"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_03.png[/img] The way things are going, you\'ve hardly a man to spare. Just as fists are about to start flying, you step in between the two men and put an end to it. You tell %oldgods% he is better than this, and you tell %cultist% nothing, for the cultist is almost bowled over in fits of laughter. He points, grinning madly.%SPEECH_ON%The light steps in, but darkness is patient. Davkul awaits you all.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "And work is waiting for you, get moving.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.OldGods.getImagePath());
				this.Characters.push(_event.m.Cultist.getImagePath());
				_event.m.OldGods.worsenMood(1.0, "Was denied the chance to enlighten a cultist");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.OldGods.getMoodState()],
					text = _event.m.OldGods.getName() + this.Const.MoodStateEvent[_event.m.OldGods.getMoodState()]
				});
				_event.m.Cultist.worsenMood(1.0, "Was denied the chance to break a follower of the old gods");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Cultist.getMoodState()],
					text = _event.m.Cultist.getName() + this.Const.MoodStateEvent[_event.m.Cultist.getMoodState()]
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getOrigin().getID() == "scenario.cultists")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local cultist_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
			{
				cultist_candidates.push(bro);
			}
		}

		if (cultist_candidates.len() == 0)
		{
			return;
		}

		local oldgods_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.monk" || bro.getBackground().getID() == "background.flagellant" || bro.getBackground().getID() == "background.pacified_flagellant" || bro.getBackground().getID() == "background.monk_turned_flagellant")
			{
				oldgods_candidates.push(bro);
			}
		}

		if (oldgods_candidates.len() == 0)
		{
			return;
		}

		this.m.Cultist = cultist_candidates[this.Math.rand(0, cultist_candidates.len() - 1)];
		this.m.OldGods = oldgods_candidates[this.Math.rand(0, oldgods_candidates.len() - 1)];
		this.m.Score = (cultist_candidates.len() + oldgods_candidates.len()) * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cultist",
			this.m.Cultist.getName()
		]);
		_vars.push([
			"oldgods",
			this.m.OldGods.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Cultist = null;
		this.m.OldGods = null;
	}

});

