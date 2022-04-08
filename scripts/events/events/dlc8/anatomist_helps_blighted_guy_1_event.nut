this.anatomist_helps_blighted_guy_1_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_helps_blighted_guy_1";
		this.m.Title = "On the road...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_53.png[/img]{You come across a man being buried alive, an inference you take from the fact that he\'s bound like a dead man yet still screaming about the whole affair. You ask what is going on and one of the diggers turns and holds a hand out.%SPEECH_ON%Keep yer distance. This man is blighted and anyone he touches becomes blighted. We don\'t want no disease, and neither should you.%SPEECH_OFF%The man cries out for help as another clump of soil lands on him. He tries to climb back out of the grave but one of the diggers kicks him back in, the kicker himself complaining he\'ll have to burn his favorite boot. %anatomist% comes over with a quieted voice. He says the man has a skin disease which might look like leprosy or a plague, but is in fact benign. You ask if he\'s sure of it, and he nods, albeit with a finger of reluctance held up.%SPEECH_ON%I may be wrong, of course. And if I am, then his very real disease might spawn itself upon us all. But to bury a man alive is not something I find, how do you say, scientifically compelling.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "In that case we\'re going to help him.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "This is not our problem.",
					function getResult( _event )
					{
						return 0;
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
			Text = "[img]gfx/ui/events/event_88.png[/img]{You draw out your sword and order the diggers to stop. They look at you with incredulous stares. One points at the man in the grave.%SPEECH_ON%Did you not hear? This fella is blighted. What we\'re doing here might not look right but-%SPEECH_OFF%With a point of your sword, the digger falls quiet. You tell the man in the grave to hop on out, and as he does the diggers drop their shovels and back off. They tell you he\'s all yours. The supposedly diseased man ambles over, still frightened and no doubt unsure if his rescuers have anything better in mind for him than those who would bury him alive. %anatomist% takes him under his wing and you slowly fall back. The anatomist states that the man is ill, but it\'s not serious and he will recover in good time. For now, though, he needs rest.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Alright.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}

				},
				{
					Text = "We don\'t need anyone else.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return "D";
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"vagabond_background"
				], false);
				_event.m.Dude.setTitle("");
				_event.m.Dude.getFlags().set("IsSpecial", true);
				_event.m.Dude.getBackground().m.RawDescription = "" + _event.m.Anatomist.getNameOnly() + " the Anatomist rescued %name% from being buried alive for carrying some strange disease. Now he has the unique pleasure of both bearing the plague AND being a lab rat for some researchers. Stay over there, please.";
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.m.Talents = [];
				local talents = _event.m.Dude.getTalents();
				talents.resize(this.Const.Attributes.COUNT, 0);
				talents[this.Const.Attributes.MeleeSkill] = 2;
				talents[this.Const.Attributes.MeleeDefense] = 2;
				talents[this.Const.Attributes.Bravery] = 2;
				_event.m.Dude.m.Attributes = [];
				_event.m.Dude.fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);

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

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).removeSelf();
				}

				_event.m.Dude.worsenMood(1.5, "Was almost buried alive for bearing a disease");
				local i = this.new("scripts/skills/injury/sickness_injury");
				i.addHealingTime(8);
				_event.m.Dude.getSkills().add(i);
				_event.m.Dude.getFlags().set("IsMilitiaCaptain", true);
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_18.png[/img]{In the most reluctant rescue ever, you sigh and draw out your sword, ordering the diggers to stop immediately. They look over at you, their hands on their shovels, their eyebrows far up their brows.%SPEECH_ON%What? Did ye you not hear us? The fella\'s blighted!%SPEECH_OFF%%anatomist% comes forward and waves them off. You nod and gesture for the diggers to do as told. The anatomist helps the man out of the grave, though you notice he\'s doing it with his own sleeve and hand covered. He is helped back to the company. As the man turns to thank you, %anatomist% drives a hammer into the back of his head, knocking him out cold. The anatomist follows him to the ground and begins to cut up the man\'s arm, removing a slab of flesh before backing away.%SPEECH_ON%This should be good enough for our studies, I believe.%SPEECH_OFF%You ask if the man was indeed sick. The anatomist nods.%SPEECH_ON%Of course, but it\'s better if he\'s at least useful while sick instead of just dead in the ground like some worm. He may, of course, go die now. There is not much left for him in this world.%SPEECH_OFF%The man moans as he writhes on the ground. There\'s a bit of a jangle in his boots which you remove to find stowed away crowns. You briefly consider putting him out of his misery, but decide that now he\'s free of the grave he may himself decide how he wishes to return to it. You do, however, take his money.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Good luck out there, man.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.improveMood(1.0, "Got to study an unusual blight");

				if (_event.m.Anatomist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				_event.m.Anatomist.addXP(200, false);
				_event.m.Anatomist.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Anatomist.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+200[/color] Experience"
				});
				this.World.Assets.addMoney(45);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]45[/color] Crowns"
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_04.png[/img]{You tell the man that the %companyname% doesn\'t need anymore sellswords. You also imply that, before he goes, he should maybe consider compensating you for the help. He nods and takes off his boot, revealing he had gold stashed in there. Not trusting what illness he has, you tell him to rub the coins on the grass and then kick it over with his feet. He does as told. He nods.%SPEECH_ON%Well. I appreciate it. You take care out there.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Good luck to you as well.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(65);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]65[/color] Crowns"
				});

				if (this.Math.rand(1, 100) < 75)
				{
					_event.m.Anatomist.worsenMood(0.75, "Was denied the study of an unusual illness");
				}
				else
				{
					_event.m.Anatomist.worsenMood(0.5, "Was denied the chance to help a sick man");
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

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomist_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomist_candidates.push(bro);
			}
		}

		if (anatomist_candidates.len() > 0)
		{
			this.m.Anatomist = anatomist_candidates[this.Math.rand(0, anatomist_candidates.len() - 1)];
		}
		else
		{
			return;
		}

		this.m.Score = 5 + anatomist_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Dude = null;
	}

});

