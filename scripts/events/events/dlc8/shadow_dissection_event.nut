this.shadow_dissection_event <- this.inherit("scripts/events/event", {
	m = {
		Talkers = [],
		Anatomist = null,
		Cultist = null,
		Monk = null,
		Mercenary = null,
		Swordmaster = null,
		Minstrel = null,
		OtherBro = null,
		Killer = null
	},
	function create()
	{
		this.m.ID = "event.shadow_dissection";
		this.m.Title = "During camp...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{The company has made camp next to an abandoned priory and the men are sitting around the campfire casting shadow animals across one of its stonewalls. First a rabbit, then a panting dog, of course the bird, the head of a snake and the little mouse for it to eat. One of the sellswords ponders what it is that these shadows get up to when they aren\'t looking. He holds his hands up, their shapes blackly set against the wall.%SPEECH_ON%I just mean we have these things following us everywhere we go, we toy with them, you know, and yet we don\'t really think much about it. I mean look at this, what is this?%SPEECH_OFF%He splays his hands wide, blobbing ten fat shadows against the wall. The men ponder...}",
			Banner = "",
			Characters = [],
			Options = [],
			function start( _event )
			{
				if (_event.m.Anatomist != null)
				{
					this.Options.push({
						Text = "What does %anatomist% the anatomist have to say?",
						function getResult( _event )
						{
							return "B";
						}

					});
				}

				if (_event.m.Cultist != null)
				{
					this.Options.push({
						Text = "%cultist% the cultist is murmuring again.",
						function getResult( _event )
						{
							return "C";
						}

					});
				}

				if (_event.m.Monk != null)
				{
					this.Options.push({
						Text = "Our monk %monk% seems keen to answer.",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				if (_event.m.Mercenary != null)
				{
					this.Options.push({
						Text = "Why\'s everyone lookin\' at the biggest sellsword?",
						function getResult( _event )
						{
							return "E";
						}

					});
				}

				if (_event.m.Swordmaster != null)
				{
					this.Options.push({
						Text = "%swordmaster% the swordmaster seems to have a word.",
						function getResult( _event )
						{
							return "F";
						}

					});
				}

				if (_event.m.Minstrel != null)
				{
					this.Options.push({
						Text = "Naturally, %minstrel% the minstrel is ready to talk.",
						function getResult( _event )
						{
							return "G";
						}

					});
				}

				if (_event.m.Killer != null && this.Options.len() < 6)
				{
					this.Options.push({
						Text = "What\'s that noise?",
						function getResult( _event )
						{
							return "H";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_184.png[/img]{%anatomist% the anatomist looks up from the campfire, his face squirming with shadows as the flames rise and fall.%SPEECH_ON%Our shadows are but cuts upon the world which wound and mend all in one stride of black, dissecting the earth with our presence and self-same shaded presence in such a transient manner that it can\'t but be a preview of our stay here. But does the shadow think of dissecting you? Does it wish to free others which are like itself? Surely it is not alone. Surely our insides have shades. Do they cast tricks of themselves against our inner walls? What of when we sleep, are these things set against us from within or do they escape out into the world and wander? Are they the guards against our own minds, departing us in the night and leaving us to the horrors of dreamscapes which are surely present when we are awake? What distills the truth of the morning light better, than our shadow cast along the ground, and the fleeting memories of that which it has returned to ward away?%SPEECH_OFF%One of the sellswords stares at him.%SPEECH_ON%What?%SPEECH_OFF%The rest of the sellswords scoff.%SPEECH_ON%Hey man, we just wanna make like dicks and slags and shite. Check this out, I\'m %anatomist%\'s shadow. Blah blah blah blah!%SPEECH_OFF%The man mimes a mouth opening and closing over and over again as the company laughs.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "At least the anatomist took it in stride.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Anatomist.getID())
					{
						bro.improveMood(0.75, "Felt intellectually superior to the other men");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(1.0, "Felt entertained");

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
			ID = "C",
			Text = "[img]gfx/ui/events/event_03.png[/img]{%cultist% the cultist leans toward the fire, his face almost touching the flames. The men glance at him as his eyes go wide, the wetness drying and peeling back until blood veins grow fat on the white. He leans back.%SPEECH_ON%Shadows are but ambassadors of the greater dark.%SPEECH_OFF%The campfire crackles and the man\'s shadow blossoms against the priory wall, and for a moment the company sees something else in that black, something twisted and leaning in, an entity not at all at the behest of %cultist%\'s shape. As the fires die down, the shadow cuts to pieces and draws away into the greater night, and only the cultist\'s own shadowed self remains, flickering uncertainly against the priory walls.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Strange shadows for a strange night.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
					{
						bro.improveMood(1.5, "Davkul awaits");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (this.Math.rand(1, 100) <= 20)
					{
						bro.worsenMood(1.0, "Unnerved by " + _event.m.Cultist.getName());

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
			Text = "[img]gfx/ui/events/event_40.png[/img]{Standing up, %monk% the monk makes an appeal to the old gods. He has one hand to his chest as the other swings upward as though in a great oratory offering.%SPEECH_ON%It is not the shadows we should mind, but the fire which has produced them, for it is the flame which the gods have bestowed upon us, such that we may carry the day into the night, and make our productive habits unending, and our allegiance to that which is good unerring.%SPEECH_OFF%The men shout \'hear hear!\'}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "May they watch over us.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Monk.getID() || bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(1.0, "Inspired by " + _event.m.Monk.getName());

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}

						if (this.Math.rand(1, 100) <= 33)
						{
							bro.getBaseProperties().Bravery += 1;
							this.List.push({
								id = 16,
								icon = "ui/icons/bravery.png",
								text = bro.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Resolve"
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_82.png[/img]{One of the mercenaries stands up and points across the campfire and announces that %mercenary% has the scariest shadow of them all. The large sellsword looks over as if annoyed his name was spoken aloud. He grits his teeth and slowly raises his hands and the rest of the company fearfully rears back. %mercenary% laces his fingers and puts the thumbs out.%SPEECH_ON%This is a chicken. See?%SPEECH_OFF%The men glance at the shadows on the wall. It looks absolutely nothing like a chicken, but nobody dares to say that. They all nod and agree.%SPEECH_ON%Frankly, %mercenary%, that is the best cock I\'ve ever seen.%SPEECH_OFF%The men roar with laughter, but %mercenary% gets to his feet and the laughter stops.%SPEECH_ON%I said it was a chicken, didn\'t I?%SPEECH_OFF%The other man nods hurriedly and agrees it was indeed a chicken. Tensions settle down, but the shadow games are effectively over.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "It sorta looked like a worm to me.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Mercenary.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Mercenary.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(0.75, "Glad he fights alongside " + _event.m.Mercenary.getName());

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (this.Math.rand(1, 100) <= 33)
					{
						bro.worsenMood(0.5, "Afraid of " + _event.m.Mercenary.getName());

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
			Text = "[img]gfx/ui/events/event_17.png[/img]{%swordmaster% the swordmaster nods and speaks to it.%SPEECH_ON%I\'ve long thought about the shadow. When you take to a fight in the light of day, are there two battles going on? One of flesh and blood, and one of the shades at your feet? When you kill a man, do you kill his shadow as well, or does your shadow kill his? What even are we to our own shadows? Because when I find myself in a fight absent of light, it is not a fight at all, but a matter of nonsense, limbs flying, swords slashing. Blindness manifest. It seems only when a shadow is at the hip can we truly say it is a fight of men, and a fight of their talents.%SPEECH_OFF%One of the sellswords tilts a mug dutifully.%SPEECH_ON%Well whatever or however things are, may my shadow never cross illwise of yours, %swordmaster%.%SPEECH_OFF%The company raises their drinks. Hear hear!}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "His shadows traverses with great danger.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Swordmaster.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Swordmaster.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(1.0, "Glad he fights with " + _event.m.Swordmaster.getName());

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
			ID = "G",
			Text = "[img]gfx/ui/events/event_26.png[/img]{%minstrel% the minstrel stands up, his head cocked to a side, his walk a shuffling amble, his eyes affixed to his own shadow upon the priory wall, every step he takes drawing it smaller and smaller yet. He stares at the shadow as though it were a body, and his closing in on it was akin to that of solving who murdered it. Suddenly, he bolts upright, hands to his hips.%SPEECH_ON%By the gods, men, I\'ve got it figured out! My shadow is an absolute womanizer! A scapegrace smellsmock. He\'s got a big hammer in his pants, and every woman\'s a nail! A philanderer, he is! And a drunk, a pitiful sot. And...and a thief! Filching crowns from the filthy, this he cannot resist. And a little prankster, a little rat filled with devilments. Just the other day, my shadow took a shit in %othersellword%\'s boot! I couldn\'t believe it!%SPEECH_OFF%%othersellsword% jumps to his feet, knocking over the fire and spewing embers that seem to twirl and twist on the laughter of the men. He comes forward.%SPEECH_ON%I knew that wasn\'t no farkin\' dogshite you bastard! What sorta man shits in another man\'s boots!%SPEECH_OFF%The sellsword slips and falls which arises applause from the company, and the minstrel delicately prances away, his shadow bidding goodbye with a kiss and wave.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "The minstrel\'s shadow gets more action than me.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Minstrel.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Minstrel.getID() || bro.getID() == _event.m.OtherBro.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 66)
					{
						bro.improveMood(1.0, "Felt entertained");

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
			ID = "H",
			Text = "[img]gfx/ui/events/event_51.png[/img]{As the men bandy back and forth making shadows, %killer%, the alleged killer on the run, walks up to the camp carrying armfuls of jewelry and other goods, their metals glistening with crimson sheens. He\'s murmuring to himself, but then suddenly stops and look at the rest of the company.%SPEECH_ON%Oh. You guys are still awake? I was just, uh, out. Doing things.%SPEECH_OFF%There\'s blood on his face and caked under his fingernails. Sensing himself in trouble, he drops the goods.%SPEECH_ON%These are for the company, of course. I\'m just so, uh, thankful that you all took me in. Thought I\'d repay the favor, you know?%SPEECH_OFF%The men stare at the goods. You ask the man if someone is going to come looking for those items. He grins.%SPEECH_ON%No sir, of course not. I made sure of it. Oh captain, did I make sure of it, heh, heh, heh.%SPEECH_OFF%You tell the man to put the goods into inventory, but to be sure to clean them up first. As he walks away, the rest of the men quietly exchange glances. There\'s no more shadow games left to play, it seems.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Would somebody please keep an eye on that man?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Killer.getImagePath());
				local item = this.new("scripts/items/loot/signet_ring_item");
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				this.World.Assets.getStash().add(item);
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomist_candidates = [];
		local cultist_candidates = [];
		local monk_candidates = [];
		local mercenary_candidates = [];
		local swordmaster_candidates = [];
		local minstrel_candidates = [];
		local killer_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomist_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.cultist")
			{
				cultist_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.monk")
			{
				monk_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.hedge_knight" || bro.getBackground().getID() == "background.raider" || bro.getBackground().getID() == "background.sellsword")
			{
				mercenary_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.swordmaster")
			{
				swordmaster_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.minstrel")
			{
				minstrel_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.killer_on_the_run")
			{
				killer_candidates.push(bro);
			}
		}

		local bro;

		if (anatomist_candidates.len() > 0)
		{
			bro = anatomist_candidates[this.Math.rand(0, anatomist_candidates.len() - 1)];
			this.m.Anatomist = bro;
			this.m.Talkers.push(bro);
		}

		if (cultist_candidates.len() > 0)
		{
			bro = cultist_candidates[this.Math.rand(0, cultist_candidates.len() - 1)];
			this.m.Cultist = bro;
			this.m.Talkers.push(bro);
		}

		if (monk_candidates.len() > 0)
		{
			bro = monk_candidates[this.Math.rand(0, monk_candidates.len() - 1)];
			this.m.Monk = bro;
			this.m.Talkers.push(bro);
		}

		if (mercenary_candidates.len() > 0)
		{
			bro = mercenary_candidates[this.Math.rand(0, mercenary_candidates.len() - 1)];
			this.m.Mercenary = bro;
			this.m.Talkers.push(bro);
		}

		if (swordmaster_candidates.len() > 0)
		{
			bro = swordmaster_candidates[this.Math.rand(0, swordmaster_candidates.len() - 1)];
			this.m.Swordmaster = bro;
			this.m.Talkers.push(bro);
		}

		if (minstrel_candidates.len() > 0)
		{
			bro = minstrel_candidates[this.Math.rand(0, minstrel_candidates.len() - 1)];

			do
			{
				this.m.OtherBro = brothers[this.Math.rand(0, brothers.len() - 1)];
			}
			while (this.m.OtherBro == null || this.m.OtherBro.getID() == bro.getID());

			this.m.Minstrel = bro;
			this.m.Talkers.push(bro);
		}

		if (killer_candidates.len() > 0)
		{
			bro = killer_candidates[this.Math.rand(0, killer_candidates.len() - 1)];
			this.m.Killer = bro;
			this.m.Talkers.push(bro);
		}

		if (this.m.Talkers.len() <= 0)
		{
			this.m.Score = 0;
		}
		else
		{
			this.m.Score = 3 * this.m.Talkers.len();
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist != null ? this.m.Anatomist.getNameOnly() : ""
		]);
		_vars.push([
			"cultist",
			this.m.Cultist != null ? this.m.Cultist.getNameOnly() : ""
		]);
		_vars.push([
			"monk",
			this.m.Monk != null ? this.m.Monk.getNameOnly() : ""
		]);
		_vars.push([
			"mercenary",
			this.m.Mercenary != null ? this.m.Mercenary.getNameOnly() : ""
		]);
		_vars.push([
			"swordmaster",
			this.m.Swordmaster != null ? this.m.Swordmaster.getNameOnly() : ""
		]);
		_vars.push([
			"minstrel",
			this.m.Minstrel != null ? this.m.Minstrel.getNameOnly() : ""
		]);
		_vars.push([
			"othersellsword",
			this.m.OtherBro != null ? this.m.OtherBro.getNameOnly() : ""
		]);
		_vars.push([
			"killer",
			this.m.Killer != null ? this.m.Killer.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Talkers = [];
		this.m.Anatomist = null;
		this.m.Cultist = null;
		this.m.Monk = null;
		this.m.Mercenary = null;
		this.m.Swordmaster = null;
		this.m.Minstrel = null;
		this.m.OtherBro = null;
		this.m.Killer = null;
	}

});

