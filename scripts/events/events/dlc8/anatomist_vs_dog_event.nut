this.anatomist_vs_dog_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Houndmaster = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_vs_dog";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_27.png[/img]{%anatomist% the anatomist comes up to you with a horrific idea: he wants to take one of the company\'s dogs and open it up. Just to be sure, you ask him if he means to kill the dog. He throws his head side to side as though to weigh the options.%SPEECH_ON%I believe from the canine\'s perspective it would be best if it had expired before we go dissecting it.%SPEECH_OFF%The anatomist explains that the use of dogs for studies isn\'t unusual, and that this requirement will be for the betterment of understanding direwolves which, by some long stretch, a dog is no doubt related. You can\'t imagine the slaughtering of a company dog will go well with the rest of the men and tell him to find one of the hundreds of mangy mutts moping around. He shakes his head.%SPEECH_ON%All dogs are almost assuredly cousin to the direwolf, but a fighting dog is of a different breed, and most assuredly the closest to the matter at heart.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Yes, do it.",
					function getResult( _event )
					{
						if (_event.m.Houndmaster != null)
						{
							return "E";
						}
						else if (this.Math.rand(1, 100) <= 50)
						{
							return "B";
						}
						else
						{
							return "C";
						}
					}

				},
				{
					Text = "No, I don\'t think so.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_37.png[/img]{You nod and tell the man to do what he must. As far as you\'re concerned, you\'re here to help these anatomists do their business, and sometimes that might mean cutting into the company funds. In this case, a fighting dog just happens to represent those funds. %anatomist% is pleased and sets off to do it. You hear the jangle of the dog\'s collar followed by a brief yelp. You tune out the sounds that come after.\n\n%anatomist% eventually reappears with bloodied hands. He nods and says that the specimen was satisfactory and that much has been learned from its fighting spirit. You tell him to bury the dog. He seems disgusted, but you glare at him and he backs off, saying he\'ll give it a proper burial.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Rest in peace, dog.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				_event.m.Anatomist.m.XP = this.Const.LevelXP[_event.m.Anatomist.getLevel()];
				_event.m.Anatomist.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/level.png",
					text = _event.m.Anatomist.getName() + " levels up"
				});
				local numWardogsToLose = 1;
				local stash = this.World.Assets.getStash().getItems();

				foreach( i, item in stash )
				{
					if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
					{
						numWardogsToLose = --numWardogsToLose;
						stash[i] = null;
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "You lose " + item.getName()
						});
						break;
					}
				}

				if (numWardogsToLose != 0)
				{
					local brothers = this.World.getPlayerRoster().getAll();

					foreach( bro in brothers )
					{
						local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

						if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
						{
							numWardogsToLose = --numWardogsToLose;
							bro.getItems().unequip(item);
							this.List.push({
								id = 10,
								icon = "ui/items/" + item.getIcon(),
								text = "You lose " + item.getName()
							});
							break;
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_19.png[/img]{You give %anatomist% the go ahead. He smiles like a child given his first gift. As he heads off, you wonder if you\'ve made the wrong choice. You hear the anatomist wrangling with the dog, the clinking of its collar and the growling of it being roughed up. You await the yelp, only to hear instead a that\'s definitely human, and even a little bit feminine. As you race over to the scene, a large dog bolts past. You find %anatomist% on the ground holding his hand. Undeterred or perhaps trying to find some educational value, the anatomist mutters sweet scientific nothings to himself.%SPEECH_ON%Ah, I think that proves that maybe it did have a little direwolf in its blood.%SPEECH_OFF%Regardless of what %anatomist% could glean from a bleeding wound, the dog itself is nowhere to be found. No doubt it even understand that such a betrayal did not emerge from nothing. If there\'s direwolf in that dog, then there\'s also regular dog in that dog, and even a dog knows when its masters have betrayed it.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Get that wound cleaned.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				local injury = _event.m.Anatomist.addInjury([
					{
						ID = "injury.missing_finger",
						Threshold = 0.0,
						Script = "injury_permanent/missing_finger_injury"
					}
				]);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Anatomist.getName() + " suffers " + injury.getNameOnly()
				});
				local numWardogsToLose = 1;
				local stash = this.World.Assets.getStash().getItems();

				foreach( i, item in stash )
				{
					if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
					{
						numWardogsToLose = --numWardogsToLose;
						stash[i] = null;
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "You lose " + item.getName()
						});
						break;
					}
				}

				if (numWardogsToLose != 0)
				{
					local brothers = this.World.getPlayerRoster().getAll();

					foreach( bro in brothers )
					{
						local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

						if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
						{
							numWardogsToLose = --numWardogsToLose;
							bro.getItems().unequip(item);
							this.List.push({
								id = 10,
								icon = "ui/items/" + item.getIcon(),
								text = "You lose " + item.getName()
							});
							break;
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_27.png[/img]{%anatomist% sighs, but does not offer much protest and ultimately submits to your denial and walks away with a bit of a slouch. You ponder if he had a tail if it would find the place between his legs just then. Just then the prospect of his scientific designs, the dog itself, appears wagging its tail and carrying a stick in its mouth. It puts the stick down at your feet, but when you go to pick the stick up the dog growls and snatches it away. Maybe these strange creatures should have been studied...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Alright, you little mutt...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				_event.m.Anatomist.worsenMood(0.5, "Was denied the opportunity to study a wardog.");
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_06.png[/img]{You let the %anatomist% do as he desires. If your job is to help them along in their scientific duties, then incidents like this are going to be a part of that. A little off a ways you can hear the anatomist wrestling with the dog and trying to pin it down for a quick death. But then you hear a man\'s voice bark in from the side, and the wrestling takes on a distinctly human tone, with more shouts and curses, and voices pleading for reprieve. You realize that you had totally forgotten about the company houndmaster. You hurry over to find %houndmaster% whipping the anatomist with a dog leash and throwing the occasional punch.%SPEECH_ON%Does this hurt, huh? How about this? Tell me, do you learn as you bleed? What do you think your teeth will taste like if I turn them into farkin\' powder, huh?%SPEECH_OFF%Sighing, you go over and pull the houndmaster off the anatomist. %houndmaster% defends himself, saying that %anatomist% was trying to kill one of the dogs. You handwave this away, saying that perhaps there must have been some miscommunication somewhere. You look down at the bloodied anatomist and tell him to stay far away from the dogs and before he can bloodily gargle some protest about how it was you who said he could do it, you simply turn and walk away.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Oops.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Houndmaster.getImagePath());
				_event.m.Anatomist.addHeavyInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Anatomist.getName() + " suffers heavy wounds"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomistCandidates = [];
		local houndmasterCandidates = [];
		local numWardogs = 0;

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist" && bro.getLevel() <= 6)
			{
				anatomistCandidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.houndmaster")
			{
				houndmasterCandidates.push(bro);
			}

			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

			if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
			{
				numWardogs = ++numWardogs;
			}
		}

		if (houndmasterCandidates.len() > 0)
		{
			this.m.Houndmaster = houndmasterCandidates[this.Math.rand(0, houndmasterCandidates.len() - 1)];
		}

		if (anatomistCandidates.len() == 0)
		{
			return;
		}

		if (numWardogs < 1)
		{
			local stash = this.World.Assets.getStash().getItems();

			foreach( item in stash )
			{
				if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
				{
					numWardogs = ++numWardogs;

					if (numWardogs >= 1)
					{
						break;
					}
				}
			}
		}

		if (numWardogs < 1)
		{
			return;
		}

		this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		this.m.Score = 8;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getNameOnly()
		]);
		_vars.push([
			"houndmaster",
			this.m.Houndmaster != null ? this.m.Houndmaster.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Houndmaster = null;
	}

});

