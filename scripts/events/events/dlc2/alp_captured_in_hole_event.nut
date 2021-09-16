this.alp_captured_in_hole_event <- this.inherit("scripts/events/event", {
	m = {
		Beastslayer = null
	},
	function create()
	{
		this.m.ID = "event.alp_captured_in_hole";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 170.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_51.png[/img]{You find a man sitting next to a hole in the ground. Beside him is a metal stake attached to which is a chain that runs into the hole. The hole is covered with goatskin. He regards you with a wave, but says if you wanna see it you\'ll have to pay. You ask what it is he\'s got. He grins.%SPEECH_ON%The darndest thing, sir.%SPEECH_OFF%A few armed men stand off a ways, no doubt a part of whatever scheme is in play here.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Alright I\'ll pay a bit to have a look.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "We\'re good.",
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
			ID = "B",
			Text = "[img]gfx/ui/events/event_51.png[/img]{You flip the man a few coins. He bites them in his teeth and you tell him to be wary of doing that, there\'s blood on some of them. He shrugs and pockets the pay. You come to the hole and the man throws the tarp off. A gruesome looking alp stares up and hisses at you with rows of sharp teeth and a face like curtain made of pale flesh. There is a shackle around its neck and the man whistles at the reveal as though it was the first time he ever saw it there.%SPEECH_ON%Awful little bugger, ain\'t it? Don\'t get too close, it\'ll have you seeing things. Unless you wanna do that, of course. Some folks do. But if you start seeing things and you enjoy then you gotta pay a little more!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You should kill it.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Alright, uh, good luck then.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local money = -10;
				this.World.Assets.addMoney(-10);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]" + money + "[/color] Crowns"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_51.png[/img]{Such hideous creatures cannot stand to survive. You tell the man that it is likely to get its way out of the hole at some point and start wreaking havoc on the world, if not moreso than usual in a fit of primeval vengeance. The man spits.%SPEECH_ON%Go fark yourself. Get on out of here and you ain\'t getting your money back. You take one wrong step and I\'ll have to defend myself and my investment. Was a right bitch capturing that thing, don\'t you know?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I\'ll kill it myself.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Fine, let it live.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Beastslayer != null)
				{
					this.Options.push({
						Text = "%beastslayer%, you\'re an expert on these things. What say you?",
						function getResult( _event )
						{
							return "F";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_60.png[/img]{You grab a spear from one of the guards and throw it into the pit, striking the alp through its brainpan. Its pale flesh deflates around the spear shaft as though you\'d struck down an enormous curtain. The monster enslaver draws a dagger and goes to stab you. %randombrother% parries the blow and cuts the man across the throat. A few guards dive into the fray, all of them dying in quick and hurried fashion, though a few of the mercenaries get hurt in the fracas. With the violence over, you collect whatever gold the enslaver had on him. You have the bodies dumped into the hole with the dead alp and then fill it up.}",
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
				local money = this.Math.rand(25, 100);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Crowns"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 33)
					{
						bro.addLightInjury();
						this.List.push({
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = bro.getName() + " suffers light wounds"
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_51.png[/img]{You\'re not going to bother quarreling with these men. Some of the best fighters you\'ve seen have gotten killed in reckless and pointless bar fights. If these idiots want to keep the monster, so be it. But a few of the company\'s mercenaries are not happy with the idea of an alp allowed to live, especially as the creature gazed its faceless stares upon a number of them and seemed to nod as though it\'d be seeing them at a later juncture.}",
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
					if (bro.getBackground().getID() == "background.beast_slayer" || bro.getBackground().getID() == "background.witchhunter" || bro.getSkills().hasSkill("trait.hate_beasts") || bro.getSkills().hasSkill("trait.fear_beasts") || bro.getSkills().hasSkill("trait.bloodthirsty") || bro.getSkills().hasSkill("trait.paranoid") || bro.getSkills().hasSkill("trait.superstitious"))
					{
						bro.worsenMood(0.75, "You let some alp live which may haunt the company later");

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
			ID = "F",
			Text = "[img]gfx/ui/events/event_122.png[/img]{%beastslayer% the beast slayer walks up to the hole and stares in. He nods.%SPEECH_ON%You don\'t have it captured. Alps cannot be captured.%SPEECH_OFF%The monster enslaver looks over and asks how so. The slayer laughs.%SPEECH_ON%Because that is no ordinary creature. This alp is biding its time. You said it sends nightmares to people looking in, yeah? Yeah, that\'s right. Fear is its blade and it is sharpening it right and steady. It is practicing its craft the best it can. Alps use environments to put their victims in and currently it\'s making do with the dirt. But eventually you\'ll look in and it\'ll be looking up, ready for the very moment, and you\'ll find yourself in the hole with it. Not you, yourself. No, the body would be spared. It will take your mind into that hole. And it will be there. You and that monstrosity alone in all the dark this world has to spare. For how long? Days, weeks. A very dangerous alp can cage your mind for what seems like years. You\'ll come out of it a fool, broken and slobbering and begging for death, that is if you still have the capacity to speak by then.%SPEECH_OFF%The slayer takes a bow from one of the enslaver\'s guards. He nocks an arrow. The alp looks up and its mouth blossoms open to rows of razor sharp teeth. The slayer shoots it right in the maw killing it instantly. He hands the bow back and unfurls his journeyman sheet.%SPEECH_ON%This is the pay I am owed. Extra for saving your soul and mind from an alp\'s forever harvest. I\'ll also be taking the alp\'s skin. Agreed?%SPEECH_OFF%The enslaver hurriedly nods.%SPEECH_ON%Yes, yes of course!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You\'ll be splitting that with the company.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Beastslayer.getImagePath());
				local money = 25;
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Crowns"
				});
				local item = this.new("scripts/items/misc/parched_skin_item");
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
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.getTime().Days < 30)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad || currentTile.Type == this.Const.World.TerrainType.Snow)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_beastslayer = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.beast_slayer")
			{
				candidates_beastslayer.push(bro);
			}
		}

		if (candidates_beastslayer.len() != 0)
		{
			this.m.Beastslayer = candidates_beastslayer[this.Math.rand(0, candidates_beastslayer.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"beastslayer",
			this.m.Beastslayer ? this.m.Beastslayer.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Beastslayer = null;
	}

});

