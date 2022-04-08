this.anatomist_exhumes_hero_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Graver = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_exhumes_hero";
		this.m.Title = "At %townname%";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_20.png[/img]{While in %townname%, you get wind of a local hero who had been recently buried. To you, this is idle news. The man probably wasn\'t even a hero if you compare him to anything above the level of rat-killer, so you pay it little mind. Naturally, the anatomists are of a different sort, and take to the news like flies to a cadaver\'s arse. They\'re propositioning that the company dig up this hero\'s corpse so that they might see by its shape and make what differentiates this \'heroic element\' from the ordinary man. %anatomist% explains.%SPEECH_ON%A hero\'s corpse is not just another corpse. It is invigorated with something else entire, some alluring drive which separates it from the rest of us.%SPEECH_OFF%Having seen your fair share in life, you assure the anatomists that the corpse will look very much like any other. They\'re quite fervent about stealing a look, though, even if it offends the masses.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Alright, let\'s go dig it up.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "No digging up graves today.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Graver != null)
				{
					this.Options.push({
						Text = "%graver%, what are you doing here?",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_46.png[/img]{After much plying, the anatomists break down your defenses and you agree to go fetch the local hero\'s dead, cold, and allegedly heroically shaped body from the grave. There\'s much stealth and sneaking done in the matter as you traipse through the graveyard like a bunch of kids up to absolutely no good, which you might as well be. The hero\'s grave is easy enough to spot, as it is adorned with flowers and other niceties.\n\n%anatomist% kicks the flowers out of the way and shovels off a kid\'s toy and hurls it across the graveyard. He quickly stakes his shovel and the digging starts. It doesn\'t take long, the soil so recently disturbed. A few items lie in the grave, and alongside them is the body itself: just an ordinary man with a pale visage. It is jerked up and out of the grave, the anatomists throwing it end over end like a piece of plywood and as it lands in the grass they chase after it like gremlins, slicing and dicing and digging into it with a disturbing fervor. When they\'re finished, they roll the body back into the grave, its shape more ragged and shredded than before. They complain that you were possibly correct, that a hero\'s body has no unusual aspects whatsoever. But rather than agree with the likes of an uneducated sellsword, they instead conclude that perhaps he wasn\'t a hero at all, and that their search will have to continue. You\'re just glad you didn\'t get caught.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Gross. Let\'s get out of here.",
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
					if (bro.getBackground().getID() == "background.anatomist")
					{
						bro.improveMood(1.0, "Got to examine a hero\'s cadaver");
						bro.worsenMood(0.5, "Was misled about the peculiarities of said cadaver");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}

						bro.addXP(150, false);
						bro.updateLevel();
						this.List.push({
							id = 16,
							icon = "ui/icons/xp_received.png",
							text = bro.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+150[/color] Experience"
						});
					}
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_141.png[/img]{After much plying, the anatomists break down your measly defenses and you agree to go fetch the local hero\'s dead, cold body from the grave. There\'s much stealth and sneaking done in the matter as you traipse through the graveyard like a bunch of kids up to absolutely no good, which you might as well be. You get to the graveyard and ask if any of them know the name of the hero. %anatomist% says he thinks it was, ironically, Mortimer.\n\nYou find such a named grave and begin the digging, but by the time you get down to the bottom of it you just find a dead cat, curled up and grey and decrepit with more worms than fur. As the anatomists hold it up, a shout shoots in from the treeline. You turn to see a young boy there crying and pointing. Before you can grab him, he turns and runs off shouting rather descriptive prose about your ill-designed venture. In return come the murmurs of the mob, and their words are lost in a frenzy, but you can still make out the name of the %companyname% and the racket a bevy of pitchforks make when they\'re clattering together. You turn to tell the anatomists to quit the digging only to see they\'re already halfway out of the graveyard and running for their lives. Cursing, you join them in the dishonorable retreat and cut out from town altogether.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "The shit they get me into...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local f = _event.m.Town.getFactionOfType(this.Const.FactionType.Settlement);
				f.addPlayerRelation(this.Const.World.Assets.RelationMinorOffense, "Your company was caught graverobbing");
				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = "Your relation to " + f.getName() + " has suffered"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.anatomist")
					{
						bro.worsenMood(0.75, "Was unable to exhume an unusual corpse");

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

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_46.png[/img]{%graver% is suddenly at your side. The graveyard familiar stakes a filthy thumb into his chest.%SPEECH_ON%Wanna dig up a corpse? I\'m yer man.%SPEECH_OFF%With his expertise on hand, you decide to go along with the anatomists\' dire plans. You find the graveyard and set across it in search of the hero\'s grave. The whole place is a pauper\'s lot, but you eventually find a marking covered in fresh flowers and other adornments which the men gracelessly stomp and kick away. The groundwork is soon started and with %graver% on hand the body is dug up in incredible speed. The anatomists set to work on the corpse, hunched over it and murmuring to one another, their curled, cloaked forms like buzzards. %graver% meanwhile roots around in the grave itself before coming up with a weapon that had been tucked into a corner. It\'s a nice find, all things considered, and almost makes this series of events worth it. You turn around to see the anatomists kick the body back into the grave, its limbs coming out of shape and flopping stiffly every which way as the hero\'s face comes to a rest, eyes open, staring into the disturbed soil where the worms are out and prodding air. Everyone having gotten what they needed, you soon depart the place before the locals show up and lynch you to the last.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s get back on the road.",
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
					if (bro.getBackground().getID() == "background.anatomist")
					{
						bro.improveMood(1.0, "Got to examine a hero\'s unusual cadaver");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}

						bro.addXP(150, false);
						bro.updateLevel();
						this.List.push({
							id = 16,
							icon = "ui/icons/xp_received.png",
							text = bro.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+150[/color] Experience"
						});
					}
				}

				_event.m.Graver.improveMood(1.0, "Put his grave-exhuming skills to use");

				if (_event.m.Graver.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Graver.getMoodState()],
						text = _event.m.Graver.getName() + this.Const.MoodStateEvent[_event.m.Graver.getMoodState()]
					});
				}

				local weaponList = [
					"arming_sword",
					"hand_axe",
					"military_pick",
					"boar_spear"
				];
				local item = this.new("scripts/items/weapons/" + weaponList[this.Math.rand(0, weaponList.len() - 1)]);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				this.World.Assets.getStash().add(item);
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Graver.getImagePath());
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

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() || t.isMilitary())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local graver_candidates = [];
		local anatomist_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.graverobber")
			{
				graver_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomist_candidates.push(bro);
			}
		}

		if (graver_candidates.len() > 0)
		{
			this.m.Graver = graver_candidates[this.Math.rand(0, graver_candidates.len() - 1)];
		}

		if (anatomist_candidates.len() > 1)
		{
			this.m.Anatomist = anatomist_candidates[this.Math.rand(0, anatomist_candidates.len() - 1)];
		}
		else
		{
			return;
		}

		this.m.Town = town;
		this.m.Score = 10 + anatomist_candidates.len();
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
		_vars.push([
			"graver",
			this.m.Graver != null ? this.m.Graver.getName() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Graver = null;
		this.m.Town = null;
	}

});

