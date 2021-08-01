this.come_across_ritual_event <- this.inherit("scripts/events/event", {
	m = {
		Cultist = null
	},
	function create()
	{
		this.m.ID = "event.come_across_ritual";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_33.png[/img]It\'s not a rare sight to find a dead body on your journey. This one, though, is rather unusual. %randombrother% takes a long look.%SPEECH_ON%What\'s that on his chest?%SPEECH_OFF%You crouch down and throw back the corpse\'s shirt. Scars run lengthwise all about his body, drawn in very familiar shapes: forests, rivers, mountains. %randombrother% walks up.%SPEECH_ON%Ain\'t that a sight. Wolves do that or something?%SPEECH_OFF%You stand back up.%SPEECH_ON%I think he did it to himself.%SPEECH_OFF%Bloody footprints lead away from the scene...",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s follow these footprints.",
					function getResult( _event )
					{
						return "Arrival";
					}

				},
				{
					Text = "This doesn\'t concern us.",
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
			ID = "Arrival",
			Text = "[img]gfx/ui/events/event_140.png[/img]As you follow the foosteps, you begin to hear the murmurs of a chant. You tell the company to rest while you sneak forward, eventually finding a large bonfire with cloaked men circling around it. They stomp their feet and throw their hands up, shouting some token words to their elder god, Davkul. It\'s a bestial ceremony, roaring and growling abound, and the men dance about with their oversized clothes like darkly spirits still angry at the world they\'d departed. %randombrother% crawls up beside you and shakes his head.%SPEECH_ON%Just what is going on down there? What should we do?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We need to stop this now. Attack!",
					function getResult( _event )
					{
						return "Àtack1";
					}

				},
				{
					Text = "Let\'s wait and see what happens.",
					function getResult( _event )
					{
						return "Observe1";
					}

				},
				{
					Text = "Time to leave. Now.",
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
			ID = "Observe1",
			Text = "[img]gfx/ui/events/event_140.png[/img]You decide to wait it out and see what happens. Just as you say that, the cultists drag an old man before the fire. He bows his head before the flames, opens his arms, and then falls in. There are no screams. Another man is pulled forward. He whispers words to a cultist, they both nod, and so too this man puts himself to the flame. A third is pushed forth, but unlike the others he is shackled and wild-eyed. He screams at the cultists.%SPEECH_ON%Fark your god, he means nothing! It\'s all a lie!%SPEECH_OFF%A face appears in the flames, its shape bulbous and churning in the smoke and fire. It is cruelty embodied, and could be no better painted by flames than by darkness itself. It turns and grins. One of the cultist shouts.%SPEECH_ON%Davkul awaits you!%SPEECH_OFF%But the prisoner kicks one of his imprisoners and tries to make a run for it.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I\'ve seen enough. We need to help him, now!",
					function getResult( _event )
					{
						return "Àtack2";
					}

				},
				{
					Text = "Hold on, let\'s see what happens next.",
					function getResult( _event )
					{
						return "Observe2";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Cultist != null)
				{
					this.Options.push({
						Text = "%cultist%, is this not your cult?",
						function getResult( _event )
						{
							return "Cultist";
						}

					});
				}

				this.Options.push({
					Text = "Time to leave. Now.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "Observe2",
			Text = "[img]gfx/ui/events/event_140.png[/img]You decide to wait and see what happens. The bonfire\'s face returns, a great magmatic maw opening up as the chained man is pushed forward. He screams and bends backward, but it\'s no use. His clothes burn away and the tatters fly backward in flailing orange ruin. His skin peels as though it were not fire, but a thousand scalpels running across his body. By sharpened white fire he is flayed. His skull is bored out, wriggling and shaking like a snake shedding its skin, and his eyes remain forever seeing though the rest of his body is stripped away by flesh and organs and bones. When he is but a skull with eyes, the face in the fire closes its mouth and the great howls of the sacrifice come to a snapping silence. The bonfire dies out in an instant, and the man, or what\'s left of him, falls to the earth. The eyes burn bright, slowly fading like a cooling hot iron.\n\n One of the cultists bends down and picks up the skull. He easily cracks it in half, dropping the brainpan while holding onto what used to be a face. As he holds the remains outward, the bones blacken and invert, creating a cruel visage of utter darkness wreathed by a rim of bone. He puts it on and begins to leave.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Now we attack!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.CivilianTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];

						for( local i = 0; i < 25; i = ++i )
						{
							local unit = clone this.Const.World.Spawn.Troops.Cultist;
							unit.Faction <- this.Const.Faction.Enemy;
							properties.Entities.push(unit);
						}

						properties.Loot = [
							"scripts/items/helmets/legendary/mask_of_davkul"
						];
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				},
				{
					Text = "We leave as well.",
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
			ID = "Cultist",
			Text = "[img]gfx/ui/events/event_140.png[/img]You ask %cultist% if he can do anything. He simply walks past you and down the hill. The group of cultists turn and look to him. He walks through the crowd to the prisoner. They talk. He whispers, the prisoner nods. When they finish, the %cultist% nods to the crowd of cultists. One member steps forward, disrobes, and pitches himself into the fire, screamless and without protest. Another cultist pitches a rake into the flames, tearing something out of it and handing it over to %cultist%. The prisoner, his life ostensibly spared in an exchange, is freed and you watch as %cultist% grabs him and takes him back up the hill. He pushes the man forward as he speaks.%SPEECH_ON%You have taken from Davkul, but the debt is paid.%SPEECH_OFF%You ask what it is he has in his hand. The cultist holds up what had been retrieved from the flames. It is a skull patched over in leathered flesh, and stretched taut over its face is a freshly singed visage, presumably of the man who had tossed himself into the fire. Slight hints of his face twist and turn, his mouth wringed ajar, misshapen by a cruel and murmuring darkness. Still holding it aloft like a native showing off a prized scalp, %cultist% speaks bluntly.%SPEECH_ON%Davkul awaits us all.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What\'s this?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/helmets/legendary/mask_of_davkul");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Àtack1",
			Text = "[img]gfx/ui/events/event_140.png[/img]You give the order to attack. Your men arm themselves and rush forward. The fire dies in an instant, swirling down to nothing but ash which plumes out in a great cloud. Once it is gone, the eerie crowd opens their arms and speak in unison.%SPEECH_ON%Davkul awaits. Come and greet him.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To arms!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.CivilianTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];

						for( local i = 0; i < 25; i = ++i )
						{
							local unit = clone this.Const.World.Spawn.Troops.Cultist;
							unit.Faction <- this.Const.Faction.Enemy;
							properties.Entities.push(unit);
						}

						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Àtack2",
			Text = "[img]gfx/ui/events/event_140.png[/img]You won\'t stand for this injustice and decide to charge and save the man. As you stand and raise your sword to give the order, the bonfire whips forth a great magmatic tentacle that grabs the chained man and yanks him into the flames. There is but the briefest of screams and then he\'s gone. The fire condenses into a pillar that quickly collapses. A plume of ash explodes outward. The man is gone and it is as if there was no fire at all. There\'s not even smoke in the sky.\n\n The cultists turn to you and point and speak in unison.%SPEECH_ON%Bring death, yours or ours, for Davkul awaits us all.%SPEECH_OFF%You waiver a moment, then give the order to charge.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To arms!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.CivilianTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];

						for( local i = 0; i < 25; i = ++i )
						{
							local unit = clone this.Const.World.Spawn.Troops.Cultist;
							unit.Faction <- this.Const.Faction.Enemy;
							properties.Entities.push(unit);
						}

						this.World.State.startScriptedCombat(properties, false, false, true);
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
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getTime().Days <= 200)
		{
			return;
		}

		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;

		foreach( t in towns )
		{
			local d = playerTile.getDistanceTo(t.getTile());

			if (d >= 4 && d <= 10)
			{
				nearTown = true;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 11 && (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 2)
		{
			return;
		}

		if (candidates.len() != 0)
		{
			this.m.Cultist = candidates[this.Math.rand(0, candidates.len() - 1)];
		}

		this.m.Score = 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cultist",
			this.m.Cultist != null ? this.m.Cultist.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Cultist = null;
	}

});

