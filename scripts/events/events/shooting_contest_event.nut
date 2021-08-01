this.shooting_contest_event <- this.inherit("scripts/events/event", {
	m = {
		Archer1 = null,
		Archer2 = null
	},
	function create()
	{
		this.m.ID = "event.shooting_contest";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img] A hint of murmuring grows louder and louder until you can no longer focus. You put your quill pen down with the sort of energy the ink bottle can take without breaking and step out of your tent. %archer1% and %archer2% are standing there bickering over who is the better shot. Seeing you, they waste little time asking if they can hold a shooting contest to decide who is right.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Alright, fine.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "We can\'t afford to waste the arrows.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Archer1.getImagePath());
				this.Characters.push(_event.m.Archer2.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_10.png[/img] You throw your hands up and tell the men to do what they must before retiring back to your tent. Outside comes the twang of released arrows quickly followed by the thwap of them finding their targets. Again and again. The din of men grows louder as what you can only assume what is a throng of observers grows. Finally, the contest is at some sort of end - indicated by a refreshing silence - and you get back to work.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Peace and quiet at last.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Archer1.getImagePath());
				this.Characters.push(_event.m.Archer2.getImagePath());
				_event.m.Archer1.getFlags().increment("ParticipatedInShootingContests", 1);
				_event.m.Archer2.getFlags().increment("ParticipatedInShootingContests", 1);
				this.World.Assets.addAmmo(-30);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_ammo.png",
						text = "Vous perdez [color=" + this.Const.UI.Color.NegativeEventValue + "]-30[/color] Ammunition"
					}
				];
				_event.m.Archer1.getBaseProperties().RangedSkill += 1;
				_event.m.Archer1.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/ranged_skill.png",
					text = _event.m.Archer1.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] de Maîtrise à Distance"
				});
				_event.m.Archer2.getBaseProperties().RangedSkill += 1;
				_event.m.Archer2.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/ranged_skill.png",
					text = _event.m.Archer2.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] de Maîtrise à Distance"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_10.png[/img]Feeling as though their arguments will never end, you give them the go-ahead to have their little competition before retiring back to your tent. Soon thereafter you hear the arrows nocking, releasing, and finding targets. Things which go \'thwang\' soon go \'thwap\' and the air is slowly filled with the din of a watching crowd. As you try to focus, you notice that the men have been shooting fervently for quite some time now. You step back out of your tent to find the two archers bickering some more, each one pointing a finger at the other before picking up an arrow and angrily launching it downrange. Their targets aren\'t even targets anymore, but small bushes of arrow shafts upon which break every other shot that lands upon them.\n\nShaking your head, you order the two men to stop at once before they use up every last arrow the company has.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Can\'t leave you men alone for two seconds!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Archer1.getImagePath());
				this.Characters.push(_event.m.Archer2.getImagePath());
				_event.m.Archer1.getFlags().increment("ParticipatedInShootingContests", 1);
				_event.m.Archer2.getFlags().increment("ParticipatedInShootingContests", 1);
				this.World.Assets.addAmmo(-60);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_ammo.png",
						text = "Vous perdez [color=" + this.Const.UI.Color.NegativeEventValue + "]-60[/color] Ammunition"
					}
				];
				_event.m.Archer1.getBaseProperties().Bravery += 1;
				_event.m.Archer1.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Archer1.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Détermination"
				});
				_event.m.Archer2.getBaseProperties().Bravery += 1;
				_event.m.Archer2.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Archer2.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Détermination"
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "You shake your head no for supplies are far too low to enage in such behavior. The men sigh and walk away, continuing to argue with one another long and loud into the distance.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "There are more important things to do.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Archer1.getImagePath());
				this.Characters.push(_event.m.Archer2.getImagePath());
				_event.m.Archer1.worsenMood(1.0, "Was denied a request");

				if (_event.m.Archer1.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Archer1.getMoodState()],
						text = _event.m.Archer1.getName() + this.Const.MoodStateEvent[_event.m.Archer1.getMoodState()]
					});
				}

				_event.m.Archer2.worsenMood(1.0, "Was denied a request");

				if (_event.m.Archer2.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Archer2.getMoodState()],
						text = _event.m.Archer2.getName() + this.Const.MoodStateEvent[_event.m.Archer2.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.Assets.getAmmo() <= 80)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.hunter" || bro.getBackground().getID() == "background.poacher" || bro.getBackground().getID() == "background.sellsword" || bro.getBackground().getID() == "background.bowyer")
			{
				if (!bro.getFlags().has("ParticipatedInShootingContests") || bro.getFlags().get("ParticipatedInShootingContests") < 3)
				{
					candidates.push(bro);
				}
			}
		}

		if (candidates.len() < 2)
		{
			return;
		}

		this.m.Archer1 = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Archer2 = null;
		this.m.Score = candidates.len() * 5;

		do
		{
			this.m.Archer2 = candidates[this.Math.rand(0, candidates.len() - 1)];
		}
		while (this.m.Archer2 == null || this.m.Archer2.getID() == this.m.Archer1.getID());
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"archer1",
			this.m.Archer1.getName()
		]);
		_vars.push([
			"archer2",
			this.m.Archer2.getName()
		]);
	}

	function onClear()
	{
		this.m.Archer1 = null;
		this.m.Archer2 = null;
	}

});

