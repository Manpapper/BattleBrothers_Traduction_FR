this.pimp_vs_harlot_event <- this.inherit("scripts/events/event", {
	m = {
		Minstrel = null,
		Monk = null,
		Tailor = null,
		Dude = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.pimp_vs_harlot";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_92.png[/img]You come across a man and woman arguing outside one of the town\'s buildings.%SPEECH_ON%Why do I give you all of it? I\'m the one doing all the work!%SPEECH_OFF%She yells. The man rubs his chin and responds.%SPEECH_ON%I manage the minge! How would you find work without me?%SPEECH_OFF%The woman, seeing you, turns and asks if you\'d sleep with her. She could be shaped like two circles and a triangle and you\'d probably still have a go. The woman throws her hands out.%SPEECH_ON%See? Half this world\'s ready for business if I so much as open my legs!%SPEECH_OFF%The wannabe-pimp asks you to talk some sense into his \'prospect.\'",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Pimps keep you safe in this world.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Nothing wrong with a sellwhore playing by her own rules.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Minstrel != null)
				{
					this.Options.push({
						Text = "Looks like our minstrel has something to say.",
						function getResult( _event )
						{
							return "Minstrel";
						}

					});
				}

				if (_event.m.Monk != null)
				{
					this.Options.push({
						Text = "Does our monk wish to speak about this... trade?",
						function getResult( _event )
						{
							return "Monk";
						}

					});
				}

				if (_event.m.Tailor != null)
				{
					this.Options.push({
						Text = "The company tailor might have some input here.",
						function getResult( _event )
						{
							return "Tailor";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_92.png[/img]You give your answer.%SPEECH_ON%A pimp provides security. Just cause every swinging dick wants what\'s between your legs don\'t make you safe. The smallest slight can bring out a customer\'s darker, more violent nature.%SPEECH_OFF% The pimp nods.%SPEECH_ON%That\'s right! Listen to \'im!%SPEECH_OFF%Thinking, the prostitute nods before suddenly slapping the pimp across the face. He cries out and rubs the welt. The woman nods again.%SPEECH_ON%This lark is supposed to protect me, really? Good day, sirs.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Damn. Thought he had a stronger pimp game.",
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
			ID = "C",
			Text = "[img]gfx/ui/events/event_92.png[/img]With a fatherly appeal you take the pimp by the shoulder.%SPEECH_ON%You can take the woman out of a whore, but you can\'t take the whore out of a woman.%SPEECH_OFF%The pimp thinks it over. You do, too, as you were never one for logic. The pimp looks at you.%SPEECH_ON%What?%SPEECH_OFF%The lady steps forward, taking the pimp by the other shoulder.%SPEECH_ON%I think he\'s saying to cut me loose.%SPEECH_OFF%When the pimp raises an eyebrow, the woman clarifies.%SPEECH_ON%Figuratively speaking.%SPEECH_OFF%The pimp sighs.%SPEECH_ON%I don\'t understand what the hell you two are saying, but alright. I thought maybe I could get a business going here. A woman here, a woman there, peddle their gooches and mooches, make some crowns, retire early. Oh well, back to grinding wheat into flour until I keel over and die.%SPEECH_OFF%The man walks off, his nose sniffling.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "The pimp game isn\'t for everyone.",
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
			ID = "Minstrel",
			Text = "[img]gfx/ui/events/event_92.png[/img]%minstrel% the minstrel glides forward.%SPEECH_ON%Ahoy, what is this but a tale of a dullard and tail of a whore? With one look I know what you need to do my friend: profess your undying love to this minge!%SPEECH_OFF%The woman crosses her arms and creases her eyebrows.%SPEECH_ON%Just what are you on abou--%SPEECH_OFF%The minstrel bats her out of the way as he raises an arm and a singly voice with it.%SPEECH_ON%Ahoyyy! Love, yes, love is in the air! Best let it flare! - and I\'m not just talking about his cock and balls. He loves you, my dear, can\'t you see? Why else would he make a harlot out of only thee? A pimp needs a diverse portfolio, not a business of one holy-oh, ohhh!%SPEECH_OFF%The pimp drops his head, face red and embarrassed. He admits it\'s true, all of it. The woman looks over, her face flushed. They lock eyes. You roll yours. They embrace and make off all lovey-dovey. %minstrel% scratches his chin.%SPEECH_ON%I\'m a poet and I didn\'t even... realize it.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Real nice work, minstrel.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Minstrel.getImagePath());
				_event.m.Minstrel.improveMood(2.0, "Enchanted by his own poetry");

				if (_event.m.Minstrel.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Minstrel.getMoodState()],
						text = _event.m.Minstrel.getName() + this.Const.MoodStateEvent[_event.m.Minstrel.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Tailor",
			Text = "[img]gfx/ui/events/event_92.png[/img]\'Tsk, tsk, tks.\' %tailor% the tailor struts on up shaking his head. He runs a finger along the prostitute\'s dress. He remarks that he thought whores were supposed to be pretty. The pimp raises his hand.%SPEECH_ON%That\'s my property you\'re spittin\' on.%SPEECH_OFF%%tailor% bows.%SPEECH_ON%Apologies, sir, but I do believe you have already spit on her yourself dressing her in such a manner. I\'d not know she\'s looking for a whore\'s coin had you not yelled at her with a pimp\'s, hm, lackadaisical sense of economics.%SPEECH_OFF%The pimp draws a dagger out and attacks. The tailor pirouettes, spinning beneath the blade\'s strike. He springs back upright and jams a thick pair of scissors to the pimp\'s throat.%SPEECH_ON%Mmm, what a quaint position to be in. I daresay you have but two ways out, and one is much shinier than the other. Yes, that\'s right, you get it don\'t you? Pay up or I\'ll cut yer throat and clip your nuts and the order which I do it just might surprise you.%SPEECH_OFF%The pimp hastily forks over some crowns to spare his life. The tailor \'snips\' his scissors closed and pockets them.%SPEECH_ON%Good. Now for some advice. You can find linens for cheap down the street yonder. The man who works the shop there is, hm, particularly good at outfitting women... and men. Tata now.%SPEECH_OFF%%tailor% turns to you with a grin and asks if he can go and visit some shops to spend his newly found gold.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Well done.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local money = this.Math.rand(100, 200);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Crowns"
				});
				_event.m.Tailor.getBaseProperties().Initiative += 2;
				_event.m.Tailor.getSkills().update();
				this.List.push({
					id = 17,
					icon = "ui/icons/initiative.png",
					text = _event.m.Tailor.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Initiative"
				});
				this.Characters.push(_event.m.Tailor.getImagePath());
				_event.m.Tailor.improveMood(1.0, "Cut a pimp down to size");

				if (_event.m.Tailor.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Tailor.getMoodState()],
						text = _event.m.Tailor.getName() + this.Const.MoodStateEvent[_event.m.Tailor.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Monk",
			Text = "[img]gfx/ui/events/event_92.png[/img]%monk% the monk steps forward. He takes the pimp by the hands. Were you to do that, the pimp would not doubt shrink back or strike you. But the holy man does it with such grace and humility that the pimp simply stares at him. The monk smiles warmly.%SPEECH_ON%This is not the path for you, that much is clear. You have not the means to handle this woman, and this is but one woman, when a pimp really needs many. The old gods tell me you are meant for a different path, one which is for hardier men. I daresay you are fit for a mercenary company. Leave the women-wrangling to the snake handlers.%SPEECH_OFF%The pimp thinks for a time, but you can tell the words have gotten to him. He asks if you\'d accept him into your company.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Alright, we\'ll take you.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "No, thanks.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Monk.improveMood(1.0, "Led a man back onto the path of rightenousness");

				if (_event.m.Monk.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Monk.getMoodState()],
						text = _event.m.Monk.getName() + this.Const.MoodStateEvent[_event.m.Monk.getMoodState()]
					});
				}

				this.Characters.push(_event.m.Monk.getImagePath());
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"pimp_background"
				]);
				_event.m.Dude.setTitle("the Pimp");
				_event.m.Dude.getBackground().m.RawDescription = "While visiting " + _event.m.Town.getName() + ", you found %name% quarreling with his only harlot. " + _event.m.Monk.getName() + " persuaded him to join the company and you agreed to take him along. Hopefully, he\'s better fighting in the shield wall than he is wrangling whores.";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getSize() >= 2 && !t.isMilitary() && !t.isSouthern() && t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
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

		if (brothers.len() < 3)
		{
			return;
		}

		local candidate_minstrel = [];
		local candidate_monk = [];
		local candidate_tailor = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.minstrel")
			{
				candidate_minstrel.push(bro);
			}
			else if (bro.getBackground().getID() == "background.monk")
			{
				candidate_monk.push(bro);
			}
			else if (bro.getBackground().getID() == "background.tailor")
			{
				candidate_tailor.push(bro);
			}
		}

		if (candidate_minstrel.len() != 0)
		{
			this.m.Minstrel = candidate_minstrel[this.Math.rand(0, candidate_minstrel.len() - 1)];
		}

		if (candidate_monk.len() != 0)
		{
			this.m.Monk = candidate_monk[this.Math.rand(0, candidate_monk.len() - 1)];
		}

		if (candidate_tailor.len() != 0)
		{
			this.m.Tailor = candidate_tailor[this.Math.rand(0, candidate_tailor.len() - 1)];
		}

		this.m.Town = town;
		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"minstrel",
			this.m.Minstrel != null ? this.m.Minstrel.getNameOnly() : ""
		]);
		_vars.push([
			"monk",
			this.m.Monk != null ? this.m.Monk.getNameOnly() : ""
		]);
		_vars.push([
			"tailor",
			this.m.Tailor != null ? this.m.Tailor.getNameOnly() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Monk = null;
		this.m.Minstrel = null;
		this.m.Tailor = null;
		this.m.Dude = null;
		this.m.Town = null;
	}

});

