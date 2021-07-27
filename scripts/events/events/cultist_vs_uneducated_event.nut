this.cultist_vs_uneducated_event <- this.inherit("scripts/events/event", {
	m = {
		Cultist = null,
		Uneducated = null
	},
	function create()
	{
		this.m.ID = "event.cultist_vs_uneducated";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]A few brothers come to you looking rather worried. They say %cultist% has been sitting with %uneducated% for a few hours now. When you ask what\'s the worry, they remind you that the cultist has a scarred forehead and speaks of incredibly strange things. Ah, right.\n\nYou go and see the two men. %uneducated% looks up at you, smiling, and says the cultist actually has a lot to teach him. Grimacing, you wonder if you should put a stop to these... lessons.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Do as you wish, as long as you don\'t forget what I hired you to do.",
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
				this.Characters.push(_event.m.Cultist.getImagePath());
				this.Characters.push(_event.m.Uneducated.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]You nod and turn away. The rest of the brothers shake their heads. By next morning, %uneducated% is found with a fresh wound on his forehead, the blood of conversion. When you ask how he is doing, he only says a few words.%SPEECH_ON%Davkul is coming.%SPEECH_OFF%Well, great.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Suit yourself.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
				this.Characters.push(_event.m.Uneducated.getImagePath());
				local background = this.new("scripts/skills/backgrounds/converted_cultist_background");
				_event.m.Uneducated.getSkills().removeByID(_event.m.Uneducated.getBackground().getID());
				_event.m.Uneducated.getSkills().add(background);
				background.buildDescription();
				background.onSetAppearance();
				this.List = [
					{
						id = 13,
						icon = background.getIcon(),
						text = _event.m.Uneducated.getName() + " has been converted to a Cultist"
					}
				];
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
			Text = "[img]gfx/ui/events/event_05.png[/img]You separate the two men, telling %uneducated% to go count some inventory. When he leaves, the cultist sneers at you.%SPEECH_ON%Davkul awaits. You see him in your sleep. You see him in the nights. His darkness is coming. No light burns forever.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Yeah, well, until then you work for me.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
				this.Characters.push(_event.m.Uneducated.getImagePath());
				_event.m.Cultist.worsenMood(2.0, "Was denied the chance to convert " + _event.m.Uneducated.getName());

				if (_event.m.Cultist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Cultist.getMoodState()],
						text = _event.m.Cultist.getName() + this.Const.MoodStateEvent[_event.m.Cultist.getMoodState()]
					});
				}
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

		if (brothers.len() < 4)
		{
			return;
		}

		local cultist_candidates = [];
		local uneducated_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getFlags().get("IsSpecial") || bro.getFlags().get("IsPlayerCharacter") || bro.getBackground().getID() == "background.slave")
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
			{
				cultist_candidates.push(bro);
			}
			else if (bro.getBackground().isLowborn() && !bro.getSkills().hasSkill("trait.bright") || !bro.getBackground().isNoble() && bro.getSkills().hasSkill("trait.dumb") || bro.getSkills().hasSkill("injury.brain_damage"))
			{
				uneducated_candidates.push(bro);
			}
		}

		if (cultist_candidates.len() == 0 || uneducated_candidates.len() == 0)
		{
			return;
		}

		this.m.Cultist = cultist_candidates[this.Math.rand(0, cultist_candidates.len() - 1)];
		this.m.Uneducated = uneducated_candidates[this.Math.rand(0, uneducated_candidates.len() - 1)];
		this.m.Score = cultist_candidates.len() * 5;
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
			"uneducated",
			this.m.Uneducated.getName()
		]);
	}

	function onClear()
	{
		this.m.Cultist = null;
		this.m.Uneducated = null;
	}

});

