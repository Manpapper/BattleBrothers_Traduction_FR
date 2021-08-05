this.monk_vs_monk_event <- this.inherit("scripts/events/event", {
	m = {
		Monk1 = null,
		Monk2 = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.monk_vs_monk";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img] Ah, the campfire is brimming with talk and chatter. The men are enjoying some beer and food when rather suddenly the shouts of two men in particular get everyone else to quiet down, not because they yell louder than the rest, but because it\'s rather out of character for the both of them: the monks %monk1% and %monk2% are screaming-deep in a theological debate.\n\nYou\'ve not the education to understand the intricacies nor complexities of what they are arguing, but you do understand that getting into another man\'s face and pointing furiously at him, or at a holy book, is probably asking for trouble one way or another.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "This doesn\'t concern me.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "A mercenary company is no place to talk religion!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk1.getImagePath());
				this.Characters.push(_event.m.Monk2.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img] For a moment, you think to stop the debate before it gets out of hand and into fists, but then you remember that this isn\'t the first time you\'ve seen two holy men exchanging rather heatedly. It\'s just what they do. So you decide to let the men hash it out. In time, their voices lower in volume, and their faces lower together into a book. They quietly peruse it, bumping heads as they draw their eyes over the pages. Finally, %monk1% raises up, pointing to some sentence.%SPEECH_ON%There! Right there! \'Man from mud\', not \'man from blood\'. Man can\'t be from blood, he is blood! Man can\'t be from himself, see? Now does it make sense?%SPEECH_OFF%Scratching his chin, %monk2% nods, but then wonders aloud.%SPEECH_ON%What if...%SPEECH_OFF%Before he can even finish the thought %monk1% slaps the book closed and throws his hands into the air.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "The holy men avert another crisis.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk1.getImagePath());
				this.Characters.push(_event.m.Monk2.getImagePath());
				_event.m.Monk1.improveMood(1.0, "Had a stimulating discourse on religious matters");

				if (_event.m.Monk1.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Monk1.getMoodState()],
						text = _event.m.Monk1.getName() + this.Const.MoodStateEvent[_event.m.Monk1.getMoodState()]
					});
				}

				_event.m.Monk2.improveMood(1, "Had a stimulating discourse on religious matters");

				if (_event.m.Monk2.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Monk2.getMoodState()],
						text = _event.m.Monk2.getName() + this.Const.MoodStateEvent[_event.m.Monk2.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_06.png[/img]Now, this isn\'t the first time you\'ve seen two monks squabbling. The last time it happened the debaters hashed it out right quick. So naturally you think these two will do the same. Alas, it isn\'t to be. Their voices grow louder and louder. You never knew monks could be so sharp-tongued. Fierceness and lewdness don\'t even begin to describe the insults being thrown back and forth. It isn\'t but a few seconds later that they are on the ground, wrestling and punching until you order %otherguy% to put an end to it.\n\nThe company of sellswords and their bloody daywork, it seems, have left a mark on the once peaceful demeanor of the two.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I suppose this is what they call a crisis of faith.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk1.getImagePath());
				this.Characters.push(_event.m.Monk2.getImagePath());
				_event.m.Monk1.getBaseProperties().Bravery += 1;
				_event.m.Monk1.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Monk1.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Détermination"
				});
				_event.m.Monk2.getBaseProperties().Bravery += 1;
				_event.m.Monk2.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Monk2.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Détermination"
				});
				_event.m.Monk1.worsenMood(1.0, "Lost his composure and resorted to violence");

				if (_event.m.Monk1.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Monk1.getMoodState()],
						text = _event.m.Monk1.getName() + this.Const.MoodStateEvent[_event.m.Monk1.getMoodState()]
					});
				}

				_event.m.Monk2.worsenMood(1.0, "Lost his composure and resorted to violence");

				if (_event.m.Monk2.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Monk2.getMoodState()],
						text = _event.m.Monk2.getName() + this.Const.MoodStateEvent[_event.m.Monk2.getMoodState()]
					});
				}

				if (this.Math.rand(1, 100) <= 50)
				{
					_event.m.Monk1.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Monk1.getName() + " souffre de blessures légères"
					});
				}
				else
				{
					local injury = _event.m.Monk1.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Monk1.getName() + " souffre de " + injury.getNameOnly()
					});
				}

				if (this.Math.rand(1, 100) <= 50)
				{
					_event.m.Monk2.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Monk2.getName() + " souffre de blessures légères"
					});
				}
				else
				{
					local injury = _event.m.Monk2.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Monk2.getName() + " souffre de " + injury.getNameOnly()
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local monk_candidates = [];
		local other_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() < 3)
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.monk")
			{
				monk_candidates.push(bro);
			}
			else
			{
				other_candidates.push(bro);
			}
		}

		if (monk_candidates.len() < 2)
		{
			return;
		}

		if (other_candidates.len() == 0)
		{
			return;
		}

		this.m.Monk1 = monk_candidates[this.Math.rand(0, monk_candidates.len() - 1)];
		this.m.Monk2 = null;
		this.m.OtherGuy = other_candidates[this.Math.rand(0, other_candidates.len() - 1)];

		do
		{
			this.m.Monk2 = monk_candidates[this.Math.rand(0, monk_candidates.len() - 1)];
		}
		while (this.m.Monk2 == null || this.m.Monk2.getID() == this.m.Monk1.getID());

		this.m.Score = monk_candidates.len() * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"monk1",
			this.m.Monk1.getNameOnly()
		]);
		_vars.push([
			"monk2",
			this.m.Monk2.getNameOnly()
		]);
		_vars.push([
			"otherguy",
			this.m.OtherGuy.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Monk1 = null;
		this.m.Monk2 = null;
		this.m.OtherGuy = null;
	}

});

