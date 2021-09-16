this.kings_guard_2_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.kings_guard_2";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 9999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_82.png[/img]{You find %guard% stretching about with surprising limberness. He looks nothing at all like the freezing, frigid man you found abandoned in the ice by those barbarians. Spotting you, he nods and comes over with a quiet voice.%SPEECH_ON%I\'m glad you trusted in me, captain. Perhaps you did it out of the kindness of your heart, but I need to show you something.%SPEECH_OFF%He flashes an emblem you have heard referenced many times, but have never seen: it carries the sigil of the King\'s Guard and its pristineness is such that there is no way it could have been a farce. The man smiles at you.%SPEECH_ON%I think I am in good health and ready to serve you as I did my liege.%SPEECH_OFF%The kings of these lands have long since fallen, replaced by squabbling lords and nobles. If this man can fight for you as he did for the kings, then the %companyname% has brighter days ahead surely.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I\'m glad we found you on that fateful day.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				local bg = this.new("scripts/skills/backgrounds/kings_guard_background");
				bg.m.IsNew = false;
				_event.m.Dude.getSkills().removeByID("background.cripple");
				_event.m.Dude.getSkills().add(bg);
				_event.m.Dude.getBackground().m.RawDescription = "You found %name% frozen half to death in the north. With your help, the former King\'s Guard regained his strength and now fights for you.";
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.improveMood(1.0, "Is his former self again");

				if (_event.m.Dude.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Dude.getMoodState()],
						text = _event.m.Dude.getName() + this.Const.MoodStateEvent[_event.m.Dude.getMoodState()]
					});
				}

				_event.m.Dude.getBaseProperties().MeleeSkill += 12;
				_event.m.Dude.getBaseProperties().MeleeDefense += 7;
				_event.m.Dude.getBaseProperties().RangedDefense += 7;
				_event.m.Dude.getBaseProperties().Hitpoints += 15;
				_event.m.Dude.getBaseProperties().Stamina += 10;
				_event.m.Dude.getBaseProperties().Initiative += 10;
				_event.m.Dude.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_defense.png",
					text = _event.m.Dude.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+7[/color] Melee Defense"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/ranged_defense.png",
					text = _event.m.Dude.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+7[/color] Ranged Defense"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Dude.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+12[/color] Melee Skill"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/fatigue.png",
					text = _event.m.Dude.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+10[/color] Max Fatigue"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Dude.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+10[/color] Initiative"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/health.png",
					text = _event.m.Dude.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+15[/color] Hitpoints"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidate;

		foreach( bro in brothers )
		{
			if (bro.getDaysWithCompany() >= 30 && bro.getFlags().get("IsKingsGuard"))
			{
				candidate = bro;
				break;
			}
		}

		if (candidate == null)
		{
			return;
		}

		this.m.Dude = candidate;
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"guard",
			this.m.Dude.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

