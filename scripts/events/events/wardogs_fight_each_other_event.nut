this.wardogs_fight_each_other_event <- this.inherit("scripts/events/event", {
	m = {
		Houndmaster = null,
		Otherbrother = null,
		Wardog1 = null,
		Wardog2 = null
	},
	function create()
	{
		this.m.ID = "event.wardogs_fight_each_other";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_37.png[/img]A series of barks followed by muted growling interrupts your work. You leave your tent to see that the two wardogs, %randomwardog1% and %randomwardog2% are fighting. They\'ve locked their jaws onto the nape of each other\'s necks. A few brothers try to intervene, but every time they do the wardogs briefly separate and snap at the humans as if to say this fight is between them and them only.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let the hounds sort it out themselves.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Someone separate the hounds!",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Houndmaster != null)
				{
					this.Options.push({
						Text = "%houndmaster%, you are a houndmaster, handle this!",
						function getResult( _event )
						{
							return "I";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_37.png[/img]You elect to stand back and let nature take its course. Once the dust settles, you step forward to see how everything shook out.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Well?",
					function getResult( _event )
					{
						local r = this.Math.rand(1, 100);

						if (r <= 20)
						{
							return "E";
						}
						else if (r <= 35)
						{
							return "F";
						}
						else
						{
							return "G";
						}
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_37.png[/img]You yell at %otherbrother% to separate the two wardogs. He takes up a long stick and lowers it into the furred and furious melee. The dogs yelp as the metal comes between them. One takes hold of the pole-handle and rips it forward, dragging the brother into the fray. Man and beast blur together as all three fight for their own survival, each taking turns at fighting off the other. As the dust settles, you take stock of who or what is still standing.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Well?",
					function getResult( _event )
					{
						local r = this.Math.rand(1, 100);

						if (r <= 10)
						{
							return "E";
						}
						else if (r <= 50)
						{
							return "F";
						}
						else if (r <= 90)
						{
							return "G";
						}
						else
						{
							return "H";
						}
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Otherbrother.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_37.png[/img]Unfortunately, both dogs passed away. They died with bloodied fur clenched in their jaws, each one sharing a sum of both victory and defeat. You have %randombrother% bury the bodies lest their smell attract even angrier beasts.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Poor beasts.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.List.push({
					id = 10,
					icon = "ui/items/" + _event.m.Wardog1.getIcon(),
					text = "Vous perdez " + _event.m.Wardog1.getName()
				});
				this.World.Assets.getStash().remove(_event.m.Wardog1);
				_event.m.Wardog1 = null;
				this.List.push({
					id = 10,
					icon = "ui/items/" + _event.m.Wardog2.getIcon(),
					text = "Vous perdez " + _event.m.Wardog2.getName()
				});
				this.World.Assets.getStash().remove(_event.m.Wardog2);
				_event.m.Wardog2 = null;
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_27.png[/img]The battle over, you have %randombrother% take a look at the wardogs. They growl as he approaches, but that\'s all they got to muster for the fight has been kicked out of them. He reports on a few broken teeth and they each got a bit of a limp, but they ain\'t lame. In time, they\'ll be good as new for fighting. Hopefully, just not fighting one another...",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Such is their nature.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_37.png[/img]One wardog limps off from the melee, leaving behind a dead mutt. That the winner did not even eat or try to eat the loser shows all you need to know about these animals\' namesake. You have %randombrother% take care of the survivor while a few other brothers bury the body of the departed.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Poor beast.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.List.push({
					id = 10,
					icon = "ui/items/" + _event.m.Wardog1.getIcon(),
					text = "Vous perdez " + _event.m.Wardog1.getName()
				});
				this.World.Assets.getStash().remove(_event.m.Wardog1);
				_event.m.Wardog1 = null;
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_34.png[/img]%otherbrother% manages to separate the two wardogs before they kill one another. Unfortunately, he paid a price heavy with bites and scratches. He\'ll survive, but you can\'t help but notice that he\'s very skittish and wary of the dogs now.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "They\'re ferocious beasts alright.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Otherbrother.getImagePath());
				local injury = _event.m.Otherbrother.addInjury(this.Const.Injury.DogBrawl);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Otherbrother.getName() + " souffre de " + injury.getNameOnly()
				});
			}

		});
		this.m.Screens.push({
			ID = "I",
			Text = "[img]gfx/ui/events/event_27.png[/img]You order %houndmaster% the houndmaster to do something. He nods and steps forward, calmly walking between the two fighting dogs. They bark and snap at each other, but both pause to eye the man coming in. One growls, but does in fact sit down. The other backs up, its tail wagging furiously, but there\'s still fire in its eyes. The houndmaster crouches down and pets them both on the head. One mutt lowers itself, and the other follows suit.\n\n The man slowly brings the dogs together, practically touching noses, and then whispers to them both. Slowly, but surely, the bestial energy leaves the dogs and their softened dispositions seem more fit for watching children than fighting in a mercenary band. The houndmaster gets back up and the dogs happily follow him. He nods.%SPEECH_ON%Just a small row between dogs, heh.%SPEECH_OFF%He walks off while the rest of the company looks on slackjawed, as if they\'d just watched some kind of procession of druidic sorcery.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "A master of his craft, indeed.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Houndmaster.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_houndmaster = [];
		local candidates_other = [];
		local candidates_wardog = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.houndmaster")
			{
				candidates_houndmaster.push(bro);
			}
			else
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_other.len() == 0)
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();

		foreach( item in stash )
		{
			if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
			{
				candidates_wardog.push(item);
			}
		}

		if (candidates_wardog.len() < 2)
		{
			return;
		}

		this.m.Otherbrother = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];

		if (candidates_houndmaster.len() != 0)
		{
			this.m.Houndmaster = candidates_houndmaster[this.Math.rand(0, candidates_houndmaster.len() - 1)];
		}

		local r = this.Math.rand(0, candidates_wardog.len() - 1);
		this.m.Wardog1 = candidates_wardog[r];
		candidates_wardog.remove(r);
		r = this.Math.rand(0, candidates_wardog.len() - 1);
		this.m.Wardog2 = candidates_wardog[r];
		this.m.Score = candidates_wardog.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"otherbrother",
			this.m.Otherbrother.getName()
		]);
		_vars.push([
			"houndmaster",
			this.m.Houndmaster != null ? this.m.Houndmaster.getNameOnly() : ""
		]);
		_vars.push([
			"randomwardog1",
			this.m.Wardog1 != null ? this.m.Wardog1.getName() : ""
		]);
		_vars.push([
			"randomwardog2",
			this.m.Wardog2 != null ? this.m.Wardog2.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Houndmaster = null;
		this.m.Otherbrother = null;
		this.m.Wardog1 = null;
		this.m.Wardog2 = null;
	}

});

