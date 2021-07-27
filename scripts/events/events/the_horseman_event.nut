this.the_horseman_event <- this.inherit("scripts/events/event", {
	m = {
		Flagellant = null,
		Butcher = null,
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.the_horseman";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%While on the path, you come to a man being dangled upside down from a tree branch. A bunch of men are sitting around him sharing a goatskin flask, looking like they\'re at the end of a day\'s hard work. When you ask what is going on, one of them looks up and smiles.%SPEECH_ON%Whipping this fella \'til he\'s raw.%SPEECH_OFF%You ask what for. Another man answers.%SPEECH_ON%Fornicating with this fella\'s wife.%SPEECH_OFF%A man drinking spurts and chokes on his drink. He wipes his mouth.%SPEECH_ON%Hardy-farkin\'-har, very funny. No, this scumbag was caught farkin my dead horse.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Let\'s talk to the dangling man.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Let\'s keep going.",
					function getResult( _event )
					{
						if (_event.m.Butcher != null)
						{
							return "Butcher";
						}
						else
						{
							return 0;
						}
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "%terrainImage%You walk over to the dangling man. There\'s blood running down his back, streaking from a dozen slashes. He\'s got a cloth covering his eyes which you pull down. Blinking, he asks what it is you want as though you\'re interrupting his own hiding. You ask him if what they say is true. He spits and clears his throat.%SPEECH_ON%I mean, yeah, but the horse was dead, so of what matter was it? Can\'t a man have his fun?%SPEECH_OFF%The horse owner gets up, brandishing a dripping whip.%SPEECH_ON%Oy, you want us to go back at it? We got all day!%SPEECH_OFF%Sighing, the dangling man asks you a question.%SPEECH_ON%Yer a sellsword, right? Why don\'t I come and fight for ya? I\'m a strong and able bodied man, a little horse, I mean worse, for the wear, but that aside, and the, uh, dead animal thing, I\'m a man of upstanding and moral sensibilities.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We\'ll cut you down.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 75)
						{
							return "C";
						}
						else
						{
							return "D";
						}
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Flagellant != null)
				{
					this.Options.push({
						Text = "%flagellantfull%, you look like you have something on your mind.",
						function getResult( _event )
						{
							return "Flagellant";
						}

					});
				}

				this.Options.push({
					Text = "Time to leave.",
					function getResult( _event )
					{
						if (_event.m.Butcher != null)
						{
							return "Butcher";
						}
						else
						{
							return 0;
						}
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "%terrainImage%You take out your blade and cut the man down. He crumples onto his shoulders and splays out, his lashed back in the dirt. The soil may as well have been salt judging by his wailing. One of the whippers stands up.%SPEECH_ON%Hey, just what do you think you\'re doing? We ain\'t finished here!%SPEECH_OFF%%randombrother% draws his weapon and the man backs off. The horse owner spits and shakes his head.%SPEECH_ON%Are you really going to defend this piece of work? Ain\'t that some fucking horseshit. I guess now I can say I\'ve seen it all which is exactly what I said when I caught this bastard porkin\' my dead horse!%SPEECH_OFF%The man catches his breath then points at the recently rescued.%SPEECH_ON%I hope you die on your first day out ya filly fiddling bastard.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Welcome aboard, you horse whore.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}

				},
				{
					Text = "Just go. We have no place for you.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"vagabond_background"
				]);
				_event.m.Dude.setTitle("the Filly Fiddler");
				_event.m.Dude.getBackground().m.RawDescription = "You found %name% being whipped for \'involving\' himself with a dead horse. Hopefully that past is, er, behind him now.";
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.setHitpoints(30);
				_event.m.Dude.improveMood(1.0, "Satisfied his needs with a dead horse");
				_event.m.Dude.worsenMood(1.0, "Got whipped");

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
				}

				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "%terrainImage%You take out your blade and cut the man down. He falls right on his head and his neck breaks with a disgusting crack. The rest of his body crumples with his legs awkwardly heaved over his own chest, a position no doubt strange to this sexual deviant. The horse owner springs to his feet.%SPEECH_ON%Well shit, sir, we was just gonna whip him good. Why\'d you go and kill him for?%SPEECH_OFF%He pauses then waves a dismissive hand.%SPEECH_ON%Shit. Shit, man. Well, alright. We\'ll just all depart in our own way and say nothing of what happened here. Ain\'t that right fellas?%SPEECH_OFF%The rest of the men nod.%SPEECH_ON%\'Course. I ain\'t ruining my life over some filly fiddler. Good going, sellsword, stupid sword swingin\' sumbitch.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Whoops.",
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
			ID = "Flagellant",
			Text = "%terrainImage%%flagellant% steps forward and takes the horse owner\'s whip. He bends it and runs the leather through his hands. Nodding, he calls it a \'fine tool\' for a good whipping, but that the men were going about it \'all the wrong way.\' He points at the wounds on the man\'s back.%SPEECH_ON%See these streaks? They\'re thin and barely opened. Don\'t let the amount of blood fool you, these are superficial. Here, let me show you a good hiding.%SPEECH_OFF%The flagellant drop the whip\'s strings, twirls them around for a moment, then strikes. The hanging man cries out. A wound opens and gapes from the tip of one rib clear across his back to the tip of another. You can see the muscle and fat bubbling beneath. %flagellant% strikes again, and again, and again. Blood splashes the flagellant as he works and the horse-porker has long since passed out. Eventually, one of the men gets to his feet and takes the whip back.%SPEECH_ON%Th-that\'s enough. You fellas get on and go, alright? Farkin\' hell...%SPEECH_OFF%Another man cuts the filly fiddler down and tends to his new, quite serious wounds. %flagellant% wipes his brow and admires his handiwork.%SPEECH_ON%Mmhmm, that\'s how it\'s done.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Yes, yes it is.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Flagellant.getImagePath());
				local meleeSkill = 1;
				local fatigue = 1;
				_event.m.Flagellant.getBaseProperties().MeleeSkill += meleeSkill;
				_event.m.Flagellant.getBaseProperties().Stamina += fatigue;
				_event.m.Flagellant.getSkills().update();
				_event.m.Flagellant.improveMood(1.0, "Put his unique skills to good use");

				if (_event.m.Flagellant.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Flagellant.getMoodState()],
						text = _event.m.Flagellant.getName() + this.Const.MoodStateEvent[_event.m.Flagellant.getMoodState()]
					});
				}

				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Flagellant.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeSkill + "[/color] Maîtrise de Mêlée"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/fatigue.png",
					text = _event.m.Flagellant.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + fatigue + "[/color] Max Fatigue"
				});
			}

		});
		this.m.Screens.push({
			ID = "Butcher",
			Text = "%terrainImage%%butcher% asks if the horse is still around. Its owner nods.%SPEECH_ON%Aye, freshly dead, freshly soiled by that prick. Why?%SPEECH_OFF%The butcher asks if he can take it off his hands. The owner shrugs.%SPEECH_ON%Yours if you want it. Though you\'d best be careful cutting around the bits he touched with his own bits.%SPEECH_OFF%Before anymore can be said, %butcher% has the man take him to the horse corpse to, well, butcher it. The company gets some questionable meat to eat.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Not sure I want that in our stocks.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Butcher.getImagePath());
				local item = this.new("scripts/items/supplies/strange_meat_item");
				this.World.Assets.getStash().add(item);
				item = this.new("scripts/items/supplies/strange_meat_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y < this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidate_flagellant = [];
		local candidate_butcher = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.flagellant")
			{
				candidate_flagellant.push(bro);
			}
			else if (bro.getBackground().getID() == "background.butcher")
			{
				candidate_butcher.push(bro);
			}
		}

		if (candidate_flagellant.len() != 0)
		{
			this.m.Flagellant = candidate_flagellant[this.Math.rand(0, candidate_flagellant.len() - 1)];
		}

		if (candidate_butcher.len() != 0)
		{
			this.m.Butcher = candidate_butcher[this.Math.rand(0, candidate_butcher.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"flagellant",
			this.m.Flagellant != null ? this.m.Flagellant.getNameOnly() : ""
		]);
		_vars.push([
			"flagellantfull",
			this.m.Flagellant != null ? this.m.Flagellant.getName() : ""
		]);
		_vars.push([
			"butcher",
			this.m.Butcher != null ? this.m.Butcher.getNameOnly() : ""
		]);
		_vars.push([
			"butcherfull",
			this.m.Butcher != null ? this.m.Butcher.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Flagellant = null;
		this.m.Butcher = null;
		this.m.Dude = null;
	}

});

