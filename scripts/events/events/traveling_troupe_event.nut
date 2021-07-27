this.traveling_troupe_event <- this.inherit("scripts/events/event", {
	m = {
		Entertainer = null,
		Noble = null,
		Payment = 0
	},
	function create()
	{
		this.m.ID = "event.traveling_troupe";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_92.png[/img]While camping beside the road, a colorful wagon trundles on up with a sort of clanking, jingling musical immodesty. You didn\'t think it a particularly big cart, but about fifteen men and women inexplicably pour out of its back. Painted faces, musical instruments, juggling balls, longswords for swallowing, wine jugs for firebreathing, the troupe of entertainers fan out and demonstrate mini-talent shows as though you\'d already paid for their services. When they finish, they clap, stomp their feet, and freeze before you, hands out, smiles across their faces. A white-faced mime ironically speaks.%SPEECH_ON%What say you, travelers, care for a show? A mere %payment% crowns to entertain you all evening!%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Sure, we\'ll pay for a show.",
					function getResult( _event )
					{
						return "Regular";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Entertainer != null)
				{
					this.Options.push({
						Text = "%entertainerfull%, what say you?",
						function getResult( _event )
						{
							return "Entertainer";
						}

					});
				}

				if (_event.m.Noble != null)
				{
					this.Options.push({
						Text = "You look like you have something on your mind, %noblefull%.",
						function getResult( _event )
						{
							return "Noble";
						}

					});
				}

				this.Options.push({
					Text = "How about you just hand over your valuables?",
					function getResult( _event )
					{
						return "Robbing";
					}

				});
				this.Options.push({
					Text = "We\'re good, thanks.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "Entertainer",
			Text = "[img]gfx/ui/events/event_26.png[/img]%entertainer% steps forward and picks up some of the troupe\'s tools of trade. He tests them out, impressing the entertainers with how well he\'s able to use their own equipment. The mime asks if perhaps they could play a couple of tunes with him. He nods and joins the entertainers, putting on a show that\'s for the ages. When it\'s all over, the troupe is so impressed that they try and recruit the man. You tell them that ain\'t happening and %entertainer% nods.%SPEECH_ON%My time is with the %companyname% now, but I appreciate the compliment.%SPEECH_OFF%You ask how much for the show, but the troupe leader shakes his head.%SPEECH_ON%No need. It was a pleasure playing with him. We\'ve not put on a show like that in some time and the practice will do us well.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bye.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Entertainer.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					bro.improveMood(1.0, "Entertained by a traveling troupe");

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "Noble",
			Text = "[img]gfx/ui/events/event_26.png[/img]Before the troupe can start, %nobleman% the nobleman gets up and asks if they know of a particular song from his days in the court.%SPEECH_ON%They used to sing it when I was a little lad. It\'s been years since I\'ve heard it.%SPEECH_OFF%The mime, again breaking character, grins and loudly proclaims that they know it. He snaps his fingers and the musicians of the group pick up their instruments. When they start, the tune is instantly catchy. It\'s a stringed and horn orchestration, played alongside a large woman singing from both heart and belly. She is a tempest of a singer, bringing both the quiet and ferocity of a large storm\'s coming and going, and her lyrics are that of incredible heroism of yore.\n\n After the troupe finishes, you ask how much you owe them. The mime shakes his head.%SPEECH_ON%No, sir, payment is not necessary. It\'s been awhile since that got requested and it was a pleasure to play it for you.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Beautiful.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Noble.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					bro.improveMood(1.0, "Entertained by a traveling troupe");

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "Robbing",
			Text = "[img]gfx/ui/events/event_60.png[/img]You order the troupe raided. The mime, this time actually in character, holds up his hands and mouths \'what?\'. But the playfulness is wiped away when %randombrother% walks up and plants a punch right on his chin. The mime goes down with a catlike cry, mewling in the mud as he nurses his jaw.\n\nThe rest of the company knocks the troupe around while raiding their wagon for goods. A juggler gets kicked right in the balls and a singer has her throat chopped by %randombrother2%\'s hand. The sword swallower tries to hide his sword the only place he knows where, but a mercenary retrieves it with a rather painful unsheathing. The firebreather drinks the entirety of his jug then asks if you want to take that, too. You have him gut-punched for his snark.\n\n When it\'s all said and done, there really isn\'t much to take as beating up jesters isn\'t the most profitable business. At least with a busted mouth maybe the mime will do his job better.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Learn to mime, you creepy prick.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-2);
				local item = this.new("scripts/items/helmets/jesters_hat");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/weapons/lute");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.Math.rand(50, 200);
				this.World.Assets.addMoney(item);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + item + "[/color] Crowns"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getSkills().hasSkill("trait.bloodthirsty") || bro.getBackground().getID() == "background.raider")
					{
						bro.improveMood(1.0, "Enjoyed beating up a traveling troupe");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
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
			ID = "Regular",
			Text = "[img]gfx/ui/events/event_26.png[/img]You pay for a show which the troupe puts on quite well. The jesters crack out some jokes, the jugglers juggle which is sorta old-hat but whatever, singers sing, swords get swallowed, fire \'breathed\', and the mime, well, he\'s godawful and you actually hope he dies.\n\n When it\'s all said and done, you do feel like you got your money\'s worth and the men are happy.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Thanks.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-_event.m.Payment);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Payment + "[/color] Crowns"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					bro.improveMood(1.0, "Entertained by a traveling troupe");

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (this.World.Assets.getMoney() < 40 * brothers.len() + 500)
		{
			return;
		}

		local candidates_entertainer = [];
		local candidates_noble = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.juggler" || bro.getBackground().getID() == "background.minstrel")
			{
				candidates_entertainer.push(bro);
			}
			else if (bro.getBackground().getID() == "background.adventurous_noble" || bro.getBackground().getID() == "background.disowned_noble")
			{
				candidates_noble.push(bro);
			}
		}

		if (candidates_entertainer.len() != 0)
		{
			this.m.Entertainer = candidates_entertainer[this.Math.rand(0, candidates_entertainer.len() - 1)];
		}

		if (candidates_noble.len() != 0)
		{
			this.m.Noble = candidates_noble[this.Math.rand(0, candidates_noble.len() - 1)];
		}

		this.m.Payment = 40 * brothers.len();
		this.m.Score = 7;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"entertainer",
			this.m.Entertainer != null ? this.m.Entertainer.getNameOnly() : ""
		]);
		_vars.push([
			"entertainerfull",
			this.m.Entertainer != null ? this.m.Entertainer.getName() : ""
		]);
		_vars.push([
			"nobleman",
			this.m.Noble != null ? this.m.Noble.getNameOnly() : ""
		]);
		_vars.push([
			"noblefull",
			this.m.Noble != null ? this.m.Noble.getName() : ""
		]);
		_vars.push([
			"payment",
			this.m.Payment
		]);
	}

	function onClear()
	{
		this.m.Entertainer = null;
		this.m.Noble = null;
		this.m.Payment = 0;
	}

});

