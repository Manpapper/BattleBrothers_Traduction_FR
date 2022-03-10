this.captured_oathbringer_event <- this.inherit("scripts/events/event", {
	m = {
		Torturer = null
	},
	function create()
	{
		this.m.ID = "event.captured_oathbringer";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_05.png[/img]{One of the men rushes into your tent exclaiming that someone has been caught sneaking into the camp. You ask if it\'s a thief. The man shakes his head.%SPEECH_ON%No, worse. He\'s an Oathbringer.%SPEECH_OFF%Sonuvabitch. You jump to your feet and rush out, finding this interloper already tied up and being battered by the Oathtakers. You break it up, coming to stand before him.%SPEECH_ON%Oathbringer, where is Anselm\'s jaw?%SPEECH_OFF%The man spits on your boot and tells you he\'d never give that up, and that the Oathtakers can go to the hells where they belong, and that Anselm himself would walk them there if he could. This blaspheming of Young Anselm\'s name draws gasps from you and your men. %randombrother% leans over.%SPEECH_ON%Just give the word, captain, and we\'ll show this Oathbringer the error of his ways.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Kill him.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Torture him.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 80 ? "C" : "D";
					}

				},
				{
					Text = "Let him go.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "{[img]gfx/ui/events/event_05.png[/img]{You draw your sword and plunge it into the man\'s heart.%SPEECH_ON%Anselm will not await you in the next life, heretic.%SPEECH_OFF%The man\'s body sags around the steel, his eyes briefly wide before settling into a half-lidded gaze at the ground. You draw out your sword and the %companyname% cheers.%SPEECH_ON%Death to all Oathbringers!%SPEECH_OFF%The Oathtakers draw out their swords and raise them to the skies as a ravenous mood sweeps over the company.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Justice has been done.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local potential_loot = [
					"armor/adorned_mail_shirt",
					"helmets/heavy_mail_coif",
					"helmets/heavy_mail_coif"
				];
				local item = this.new("scripts/items/" + potential_loot[this.Math.rand(0, potential_loot.len() - 1)]);
				item.setCondition(this.Math.max(1, item.getConditionMax() * this.Math.rand(10, 30) * 0.01));
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				this.World.Assets.getStash().add(item);
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.paladin" || !bro.getBackground().isOffendedByViolence() && this.Math.rand(1, 100) <= 75)
					{
						bro.improveMood(0.75, "Pleased you slew an Oathbringer heretic");

						if (bro.getMoodState() > this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getBackground().isOffendedByViolence())
					{
						bro.worsenMood(0.5, "Disliked that you slew a captive in cold blood");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "{[img]gfx/ui/events/event_05.png[/img]{You nod.%SPEECH_ON%Torture him until his tongue points us to Young Anselm\'s jaw. I don\'t care how you do it, just do it.%SPEECH_OFF%Turning away, the prisoner screams out that Anselm would not approve. He then just starts screaming indiscriminately and eventually shouting out things that don\'t make a whole lot of sense. You retire to your tent, bouncing your foot to the screams that now take a rhythmic sort of wailing. Eventually, %randombrother% reappears. He has with him some weapons and armor you know weren\'t in inventory.%SPEECH_ON%He led us to a location that had these hidden away, but Anselm\'s jawbone is still missing. I\'m afraid the Oathbringers must have it in their own camp, but he wouldn\'t say where that was. We, uh, we had some difficulties communicating after we cut his tongue out.%SPEECH_OFF%Sighing, you ask where the prisoner is now. The man clears his throat.%SPEECH_ON%Oh he went all white and fell over. He\'s dead, sir.%SPEECH_OFF%We did right by Young Anselm, at least.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We\'ll find the jawbone yet.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local potential_loot = [
					"armor/adorned_warriors_armor",
					"helmets/adorned_closed_flat_top_with_mail",
					"helmets/adorned_closed_flat_top_with_mail"
				];
				local item = this.new("scripts/items/" + potential_loot[this.Math.rand(0, potential_loot.len() - 1)]);
				item.setCondition(this.Math.max(1, item.getConditionMax() * this.Math.rand(10, 30) * 0.01));
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				this.World.Assets.getStash().add(item);
				potential_loot = [
					"weapons/arming_sword",
					"weapons/fighting_axe",
					"weapons/military_cleaver",
					"shields/heater_shield"
				];
				local item = this.new("scripts/items/" + potential_loot[this.Math.rand(0, potential_loot.len() - 1)]);
				item.setCondition(this.Math.max(1, item.getConditionMax() * this.Math.rand(10, 30) * 0.01));
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				this.World.Assets.getStash().add(item);
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.paladin" || !bro.getBackground().isOffendedByViolence() && this.Math.rand(1, 100) <= 75)
					{
						bro.improveMood(1.25, "Tortured an Oathbringer heretic");

						if (bro.getMoodState() > this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getBackground().isOffendedByViolence())
					{
						bro.worsenMood(0.75, "Is horrified that you ordered a captive tortured");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "{[img]gfx/ui/events/event_05.png[/img]{You tell the men to torture the man for information. If there\'s one thing every Oathbringer knows, it\'s where Young Anselm\'s jawbone is and that is something every Oathtaker wishes to find out. The man screams as he\'s dragged away, and you retire to your tent to drown out the annoyances of things like shrieking and crying which really put a crimp on your mood. A moment later, %torturer% enters the tent, blood on his shirt. He looks to speak, then collapses to the ground. Another Oathtaker comes in saying the prisoner escaped, shanking his torturer before fleeing. You tell the men to help %torturer% before he bleeds out.%SPEECH_ON%Those damned Oathbringers have no honor! We\'ll find and kill him dead, so sayeth Young Anselm, so sayeth us all!%SPEECH_OFF%You speak with a clenched jaw, and an air of theatrics. The truth is the bastard got away and those Oathbringers are hard to catch, the rats that they are. You just hope that %torturer% survives.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Damn Oathbringer scum.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Torturer.addHeavyInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Torturer.getName() + " suffers heavy wounds"
				});
				local injury = _event.m.Torturer.addInjury([
					{
						ID = "injury.cut_throat",
						Threshold = 0.0,
						Script = "injury/cut_throat_injury"
					}
				]);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Torturer.getName() + " suffers " + injury.getNameOnly()
				});
				_event.m.Torturer.worsenMood(0.5, "Let a captive Oathbringer escape");
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "{[img]gfx/ui/events/event_05.png[/img]{This man has nothing of value. You tell the men to cut him loose. They protest, saying that an Oathbringer has but one choice, to submit to the Oathtakers and to the true Final Path, or to die. There is also room for one who returns Young Anselm\'s jawbone, but the codes on how to treat an Oathbringer who does that have not yet been worked out. But, as far as this man is concerned, he is of no real use and you\'re in no mood for bloodspilling. Just as you reiterate to cut him loose, %randombrother% cuts the man\'s throat, much to the cheering of the others.%SPEECH_ON%You said cut him, right captain? Right?%SPEECH_OFF%You realize the Oathtaker is covering for you, and to keep denying that the Oathbringer had to die might put you in a prickly situation. You nod.%SPEECH_ON%Yes, of course, the little rat had to die, same as all the pathless Oathbringers! And die they all shall!%SPEECH_OFF%The men roar again though you have a feeling that a few will remember your ridiculous suggestion to let an Oathbringer walk.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I should be more careful what I say.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.paladin" || this.Math.rand(1, 100) <= 75)
					{
						bro.worsenMood(0.75, "You almost let a captive Oathbringer roam free");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.paladins")
		{
			return;
		}

		if (this.World.getTime().Days < 35)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local torturer_candidates = [];
		local haveSkull = false;

		foreach( bro in brothers )
		{
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

			if (item != null && item.getID() == "accessory.oathtaker_skull_02")
			{
				haveSkull = true;
			}

			if (bro.getBackground().getID() == "background.paladin")
			{
				torturer_candidates.push(bro);
			}
		}

		if (!haveSkull)
		{
			local stash = this.World.Assets.getStash().getItems();

			foreach( item in stash )
			{
				if (item != null && item.getID() == "accessory.oathtaker_skull_02")
				{
					haveSkull = true;
					break;
				}
			}
		}

		if (haveSkull)
		{
			return;
		}

		if (torturer_candidates.len() == 0)
		{
			torturer_candidates.push(brothers[this.Math.rand(0, this.brother.len() - 1)]);
		}

		this.m.Torturer = torturer_candidates[this.Math.rand(0, torturer_candidates.len() - 1)];
		this.m.Score = 7;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"torturer",
			this.m.Torturer.getName()
		]);
	}

	function onClear()
	{
		this.m.Torturer = null;
	}

});

