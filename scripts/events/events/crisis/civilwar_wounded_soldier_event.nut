this.civilwar_wounded_soldier_event <- this.inherit("scripts/events/event", {
	m = {
		NobleHouse = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_wounded_soldier";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_21.png[/img]{While marching along a path, you come across a soldier of %noblehouse%, your allies. He\'s on the ground, leaning against a rock wall, one arm draped over the top of it as if he\'d just placed the last stone. Looking up at you, he sneers.%SPEECH_ON%Whatcha want, mercenary? You come to finish me off, huh? Take all I got and more?%SPEECH_OFF%He\'s wearing a nice set of armor and has a weapon on him. Not that he\'ll be defending himself with it in his current state, but it\'d look good in the hands of one of your men. %randombrother% walks up.%SPEECH_ON%We can take him, sir, but we should make it quick. Who knows who could catch us for he wears the cloth of a nobleman\'s army.%SPEECH_OFF% | You come across a wounded soldier of %noblehouse%, your allies. Lying in the grass, he postures up to get a good look at you and you get a good look at him in return: the man is adorned with a decent armor piece and he\'s got a weapon balanced across his legs. You could take both, but the man does not seem willing to peacefully part with either. And there\'s a good chance the rest of the soldier\'s army is not far off... | A wounded soldier of %noblehouse%, your allies, lays in the path. He\'s dragging himself away, but upon hearing you he stops and turns around.%SPEECH_ON%Ah hell. You\'d best turn \'round, mercenary. My men are not far yonder and if you come after me I\'ll scream.%SPEECH_OFF%You raise an eyebrow.%SPEECH_ON%You\'ll go out like a woman, eh?%SPEECH_OFF%The man spits.%SPEECH_ON%I\'ll go out knowing I won\'t have to wait long to meet ya again in the next world.%SPEECH_OFF%The snarky git has a nice set of armor and weapons on him, but %randombrother% does warn he is a member of a nobleman\'s army. | A wounded soldier of %noblehouse%\'s army lies before you. On one hand, he does have a weapon and some armor you could take from him. On the other hand, he is no doubt party to a much, much larger force than yours. It just happens to not be watching at this very moment. If you decide to take his things, be sure to be quick about it. | Luck or impending disaster? You\'ve found a wounded soldier dressed in reasonably nice looking armor. He\'s also got a weapon by his side that\'d look even better by the side of one of the %companyname%\'s men. Taking his things would be a cinch. No one\'s around to see and muffling him wouldn\'t be that hard.\n\nThen again, if someone were to see it\'d most likely be someone party to a very, very large army because this soldier happens to wear the cloth of %noblehouse%, your ally. Decisions, decisions... | You come across a wounded soldier wearing a shredded banner of %noblehouse%, your ally. Seeing you, he quickly scoots backward across the grass. He throws his hand out and tries to curse, but only blood spits from his mouth. %randombrother% walks up to you.%SPEECH_ON%Sir, he\'s got a nice set of armor and a weapon on him. We could take him out, if you want, but there is a risk that his army is not far off. We should be very careful about this.%SPEECH_OFF% | You find a soldier of %noblehouse% trying to kick in the door of an abandoned hovel. Hearing you, he quickly wheels around, lifting a sword up to defend himself. The blade, however, wobbles in an unsteady grip. Blood runs the length of his arm, dripping off at the wrist, and the man is struggling to stand.%SPEECH_ON%Stay back, the lot of you!%SPEECH_OFF%A fearful man backed into a corner. How unfortunate he isn\'t an animal, lest you\'d think twice about...\n\n %randombrother% grabs you by the arm.%SPEECH_ON%Hold on, sir. If the rest of his army spots us we are going to be in some real trouble. Let\'s try and think this out, yeah?%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			Banner = "",
			Options = [
				{
					Text = "We better leave him alone and move on.",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "That armor and weapon may be useful, and he won\'t be needing them in the afterlife.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(-1);

						if (this.Math.rand(1, 100) <= 50)
						{
							return "B";
						}
						else
						{
							return "C";
						}
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_21.png[/img]{You unsheathe your sword and approach the soldier. He cries out, but it is brief, ending on the sharp twang of your blade running his tongue through the back of his head. Gargling, he batters the metal of the killing blow before settling down. Shivering eyes look up at you as a cold death takes him. Retrieving your sword, you look over your shoulder and tell the men to take everything he had on him. You wipe your blade on the cloth of the dead man\'s banner. | The man sees in the intent in your eyes and quickly raises his voice, but you dash forward, unsheathing your blade and running it through his brainpan in one swift motion. He dies, and you feel a pang in your side. Not a moral one, but an older, more real pain. %randombrother% steadies you with a hand on your shoulder.%SPEECH_ON%Easy, sir, you\'re not as limber as you once were.%SPEECH_OFF%Nodding, you clean your blade and tell the men to loot what they can. | The soldier leans back.%SPEECH_ON%Ah, I see.%SPEECH_OFF%He lifts his neck.%SPEECH_ON%You got me. I\'ll go out like a man should.%SPEECH_OFF%With a quick cut, he puts his head back down, a bubbling crimson froth running down his chest. Your men loot what they can. | You take out your dagger. The man lifts his weapon, but you kick it aside. His arm falls effortlessly, as though you\'d actually just relieved him of a huge burden. He stares up at you.%SPEECH_ON%Wait...%SPEECH_OFF%That is his last word. He tries to utter something else, but the massive gash you\'ve opened across his throat only produces horrid gargling. You order %randombrother% to loot all that he can from the body.}",
			Image = "",
			Characters = [],
			List = [],
			Banner = "",
			Options = [
				{
					Text = "Another casualty of war.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.addLoot(this.List);
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_90.png[/img]{You take out your sword and step toward the man. He puts his hand up and you drive the blade through his palm and straight into his brainpan. His tongue lolls his final words, some slobbering bloodslaked utterance. Cleaning your blade, you turn to %randombrother%, only to see bannermen standing on the horizon.%SPEECH_ON%Oh bloody shite. Everybody run!%SPEECH_OFF%The %companyname% makes a quick, though messy escape, bounding through copses and creekbeds and doubling back and hiding and silently killing one hound dog before it could bark. You manage to get away in the end, but without time to take anything. | You take out your sword and plunge it into the man\'s chest. He reaches out and grabs you by your shirt, pulling himself up the blade. He bears his teeth in a bloodying grin.%SPEECH_ON%Go fark yourself, mercenary. I\'ll see you on the other side.%SPEECH_OFF%He lets go and falls back, a gush of red spewing out as your sword leaves him. Suddenly, %randombrother% calls to you, his voice pitched high.%SPEECH_ON%Sir, we should go! The bannermen, look!%SPEECH_OFF%Standing atop a nearby hill are the riders of %noblehouse% and they no doubt saw what you did. Shouting as loud as you can, you order the men to beat a quick retreat. Although you manage to get away, you no doubt exchanged for good will of your potential employer. | The soldier laughs as you bear down on him. He laughs as you stick him in the chest with your sword. And he laughs, a final, tired guffaw, as you retrieve your blade. His eyes fade staring beyond you at a nearby hill where, apparently, the killing joke stands: the soldier\'s bannermen are astride the horizon, having ostensibly seen your deed.\n\nShouting, you order the %companyname% to make a hasty retreat lest a whole army bear down on you and slaughter you to a man. In the hurried flight you forego taking any prize for your deed. A reasonable exchange for keeping your heads on your shoulders, though. | With a quick slash of your sword you open the man\'s throat. He claps his hand over the wound, but his life slips between his fingers quite literally. As he falls over, %randombrother% shouts to you.%SPEECH_ON%Sir, look!%SPEECH_OFF%The soldier\'s fellow bannermen are standing on a far hill, no doubt having seen what you just did. With a quick order, you get the %companyname% on a hurried withdrawal, leaving the area as quick as you can before an entire army bears down on top of you. In the frenzied retreat you have no time to take any prize for your bloody deed.}",
			Image = "",
			Characters = [],
			List = [],
			Banner = "",
			Options = [
				{
					Text = "Hubris! Survivable hubris!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationOffense, "Killed one of their men");
			}

		});
	}

	function addLoot( _list )
	{
		local item;
		local banner = this.m.NobleHouse.getBanner();
		local r;
		r = this.Math.rand(1, 4);

		if (r == 1)
		{
			item = this.new("scripts/items/weapons/arming_sword");
		}
		else if (r == 2)
		{
			item = this.new("scripts/items/weapons/morning_star");
		}
		else if (r == 3)
		{
			item = this.new("scripts/items/weapons/military_pick");
		}
		else if (r == 4)
		{
			item = this.new("scripts/items/weapons/warbrand");
		}

		this.World.Assets.getStash().add(item);
		_list.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
		});
		r = this.Math.rand(1, 4);

		if (r == 1)
		{
			item = this.new("scripts/items/armor/special/heraldic_armor");
			item.setFaction(banner);
		}
		else if (r == 2)
		{
			item = this.new("scripts/items/helmets/faction_helm");
			item.setVariant(banner);
		}
		else if (r == 3)
		{
			item = this.new("scripts/items/armor/mail_shirt");
		}
		else if (r == 4)
		{
			item = this.new("scripts/items/armor/mail_hauberk");
			item.setVariant(28);
		}

		item.setCondition(44.0);
		this.World.Assets.getStash().add(item);
		_list.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
		});
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isCivilWar())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local nobleHouses = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		local candidates = [];

		foreach( h in nobleHouses )
		{
			if (h.isAlliedWithPlayer())
			{
				candidates.push(h);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.NobleHouse = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"noblehouse",
			this.m.NobleHouse.getName()
		]);
	}

	function onClear()
	{
		this.m.NobleHouse = null;
	}

});

