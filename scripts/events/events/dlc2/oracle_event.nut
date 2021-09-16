this.oracle_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.oracle";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_11.png[/img]{You come across a goatskin tent beside the road. The hide tarps have been dipped in purple dyes and there are fresh daisies twisted into the knots of matted goat hair. An old woman with a hunchback stands outside with her hands clasped and hanging. She sizes you up and down with withered eyes.%SPEECH_ON%Ah, a sellsword. No, a captain of sellswords. Or perhaps something more. You smell of a strange odor, and not just that of a man. Do you wish to have your fortune told?%SPEECH_OFF%She gestures to inside the tent. You see a number of long, cards laid facedown across the table.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tell me my fortune, old woman.",
					function getResult( _event )
					{
						local r = this.Math.rand(1, 100);

						if (r <= 20 && this.World.getTime().Days > 15)
						{
							return "D";
						}
						else if (r <= 80)
						{
							return "E";
						}
						else
						{
							return "F";
						}
					}

				},
				{
					Text = "I\'ll tell you yours instead: You\'re about to give us all your valuables.",
					function getResult( _event )
					{
						local r = this.Math.rand(1, 100);

						if (r <= 50)
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
					Text = "No, we\'re good.",
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
			Text = "[img]gfx/ui/events/event_11.png[/img]{A card reader such as this has probably done a fair bit of business, enough so that you wouldn\'t mind taking it for yourself. You order the company to pick the place apart. The woman says nothing as you move her out of the way, and she says nothing as the sellswords swarm her tent and tilt its pole to the ground. She smiles a little as they throw the goatskin tarp off to see the loot like magicians unveiling a failed trick. The smile fades as they begin to pick through her things, their boots crushing and smashing anything of no use to them. The hag shrugs and holds up two cards seemingly pulled right out of her sleeves.%SPEECH_ON%Tell me, sellsword, what do you see?%SPEECH_OFF%You take a look. The tarot cards depict a group of knights ransacking a village, and another is of a graveyard guarded by a particularly punitive keeper. You shrug and tell her she keeps those two cards tucked for events just like this and you\'re no fool to the notion of a helpless hag being runover on the road. You tell her she may have scared a few robbers with that trick, but you\'re not so easily fooled. She laughs.%SPEECH_ON%You are as wise as you are cruel.%SPEECH_OFF%Damn straight. Now let\'s see what the company has found.}",
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
				this.World.Assets.addMoralReputation(-1);
				local money = this.Math.rand(75, 200);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Crowns"
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_11.png[/img]{You take a good look around you. If the hag had an ambush waiting somewhere you certainly don\'t see it. With a wave of your hand, you order the company to ransack her place. A few brothers slide into her tent and start picking it apart, flipping tables and yanking out drawers. The old woman steps aside, and keeps stepping, and keeps stepping. She\'s... grinning?%SPEECH_ON%Ay, take a look at this thing!%SPEECH_OFF%You turn back to see one of the mercenaries grabbing an orb that hangs from the tent ceiling. He yanks it down. The chain goes taut, snags, and there\'s a clank of a wire snapping loose. Blue sparks sidewind up the chain and zip down the length right into the orb. You don\'t hear a thing. The tent rips apart in a burst of blue flame and the pole punches into the sky and the silhouettes of sellswords stumble through the hot smoke. Grey and burning daisies twist through the air. You augur your ears to get your hearing back and then look to see where the woman is, but she\'s gone. Pursing your lips, you rush to see what damage has been done.}",
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
				this.World.Assets.addMoralReputation(-1);
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
			ID = "D",
			Text = "[img]gfx/ui/events/event_11.png[/img]{The tent closes shut as you step in. An orange glow flicks and bobs from a lantern. Groaning, the old woman leans into it with a candlestick and broadens the light to a table and two chairs. She motions toward them.%SPEECH_ON%Sit.%SPEECH_OFF%You sit. She sits. She smacks her lips over toothless gums and nods and begins flipping the cards.%SPEECH_ON%First there is...%SPEECH_OFF%You lean forward to get a better look and the table breaks beneath your weight. The cards go fluttering and the woman falls backwards and the candle goes flying. You catch its stick midair with one hand and rush to save the lady from falling with the other. You set her back down and give her candle back. She stares at you, grinning with a black rim of a smile, her eyes squinted into dots.%SPEECH_ON%Let\'s forget this happened and say you get all that you ever wished for, sellsword, starting with this.%SPEECH_OFF%She gives you a slobbery kiss on the forehead and prods you with a dagger handle.%SPEECH_ON%Deal!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What a dame.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/weapons/named/named_dagger");
				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_11.png[/img]{You step into the tent. A concerned %randombrother% looks in as the folds close him and the rest of the world out. The old woman lights a candle and carries it to her seat. Ironically, her olden shapes take further prominence in the dark as shadows find crevices you never knew could exist on a person, and her skin brims with lightning brought permanence. She immediately starts flipping cards and speaking.%SPEECH_ON%Defeat. Speculation. Doubt.%SPEECH_OFF%Poorly painted knights come and go, their limbs askew in bizarre poses.%SPEECH_ON%More defeat. But, also, victory. Many victories. You forget weakness. You grow tired of its contagious nature. You become powerful. Strength is survival. And there you are. Old. You die.%SPEECH_OFF%Raising an eyebrow you grab that last card and slide it into the light. You see a man with a long grey beard sitting in a chair. You tell the woman you\'ve never really been able to grow a beard and she snuffs the candle out and shoos you out of the tent.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I should stop shaving.",
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
			ID = "F",
			Text = "[img]gfx/ui/events/event_11.png[/img]{You step into the tent and its folds close and you\'re in nothing but darkness. You stand there for a time and ask the woman where she went. Pursing your lips, you open the tent flap to bring in some light. The slip of light strikes a sheen from the darkness and you turn around to see the dagger soaring forward. You block it away with your gauntlet and draw your sword and plunge it into the hag\'s chest. She drops the knife and clutches your shoulder.%SPEECH_ON%Such a monster you are, sellsword, killing a kind old woman such as I. You\'ll die for this. You and your men will all die.%SPEECH_OFF%You bring the witch in close and get a look at suddenly bright, wicked cat eyes. You spit and nod.%SPEECH_ON%Foretelling doom in a world where everything dies? Not a hard job. Do you know what my job is, you witch?%SPEECH_OFF%She grins a black rind of a gummy smile. Black blood spurts over her lips as she laughs.%SPEECH_ON%Oh, sellsword! We shall see what you are when Davkul has you in his hands.%SPEECH_OFF%The witch\'s body goes limp and your sword suddenly cuts straight through her flesh, leaving sliced flesh folding at your feet. You quickly exit the tent and have the whole thing burned. Some of the men swear they can see the woman\'s face grinning in the palls of smoke.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Burn the witch!",
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
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.Type == this.Const.World.TerrainType.Snow || currentTile.Type == this.Const.World.TerrainType.SnowyForest)
		{
			return;
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

