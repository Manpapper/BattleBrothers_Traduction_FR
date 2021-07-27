this.historian_mysterious_text_event <- this.inherit("scripts/events/event", {
	m = {
		Historian = null
	},
	function create()
	{
		this.m.ID = "event.historian_mysterious_text";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_57.png[/img]You come across an abandoned chapel. Cobwebs dress its cracks, and bird nests the corners. The pews are tipped over or have been chopped up for firewood. The old gods have surely left this place.\n\n %historian% the historian comes to you with what look like muddy logs in his hands.%SPEECH_ON%Would you look at this? Old scripts!%SPEECH_OFF%He blows the blackened dust and ash off the scrolls.%SPEECH_ON%Have you ever seen something so spectacular? I don\'t know what they say yet, but it\'s still a most interesting of finds!%SPEECH_OFF%Right, whatever.",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Just read it and tell me what it says already.",
					function getResult( _event )
					{
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
				this.Characters.push(_event.m.Historian.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_15.png[/img]As you make camp outside the temple, %historian% the historian enters your tent.%SPEECH_ON%Sir, I think you might be interested in this.%SPEECH_OFF%He\'s got the scrolls from the chapel in his arms and unravels a few of them across your desk. There you see the historian\'s sloppy scribblings. His notes are in a language you can\'t read, but you can easily follow the arrows he\'s drawn over the pages to connect segments together. He then unfurls another scroll, a fresh one, with all the translations.%SPEECH_ON%These are old training manuals. They speak of techniques I never knew existed. Shall I disperse them amongst the men?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Disperse them you shall.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Historian.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					bro.getBaseProperties().RangedDefense += 1;
					bro.getSkills().update();
					this.List.push({
						id = 16,
						icon = "ui/icons/ranged_defense.png",
						text = bro.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Ranged Defense"
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_15.png[/img]While sitting in your tent outside the abandoned temple, %historian% the historian enters in a manner best described as reluctant. In his hands are the scrolls he found in the chapel a few days back.%SPEECH_ON%Sir, uh, the scrolls... they were most interesting.%SPEECH_OFF%Bored, you inquire as to \'how interesting.\' The man explains.%SPEECH_ON%Well, they\'ve been written in a very ancient language. I\'m not well versed in it, but I can certainly read portions here and there.%SPEECH_OFF%You ask him what he wants then.%SPEECH_ON%I\'d like to read the scrolls, but I could use a little bit of confidence before I do. Would you grace the reading? That is what my old professors would do before any great undertaking.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Alright, go on ahead and read.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "D";
						}
						else
						{
							return "E";
						}
					}

				},
				{
					Text = "If you\'re so scared to read, perhaps it is best we don\'t.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Historian.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_12.png[/img]%historian% picks up the scrolls. He licks his lips, clears his throat, and begins to read aloud. The words that come forth are not ones you\'d easily recognize. They sound so lazily produced as though he were a man being wrangled from a deep sleep, and indeed bringing with him the monsters that would inhabit the dreamworlds.\n\n He stops and looks up.%SPEECH_ON%That was it. Do you feel anything?%SPEECH_OFF%You raise an eyebrow. Feel anything? Why would--\n\n Madness. You see a spiraling darkness wreathed in living shadows, the screaming specters of creatures that still yet yearn for finality in death, and amongst them swirl beings, grinning and yapping, like bestial puppet masters, maws slipped to yonder depths, their boned teeth the only light in this realm, their smiles but crescents of ill-shaped moons come to feast on the stars themselves.%SPEECH_ON%Oh naive one, does thou think Davkul does not listen?%SPEECH_OFF%You suddenly awake to %historian%\'s screams. He says all manner of monsters are afoot. With not a moment to waste you go to warn the men before all the hells and those not yet known can break loose.",
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
						properties.Music = this.Const.Music.BeastsTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
						properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Direwolves, this.Math.rand(40, 70), this.Const.Faction.Enemy);
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Ghouls, this.Math.rand(40, 70), this.Const.Faction.Enemy);
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Historian.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_15.png[/img]%historian% picks up the scroll and begins to read. The language is at both familiar and yet primordially ancient. It tickles the ear like the scratch of vipers over sand and by no means any less threatening. When he\'s finished, the historian looks up.%SPEECH_ON%Feel anything?%SPEECH_OFF%Suddenly a dark, yet soft hand wraps around the man from behind, curving down toward his loins.%SPEECH_ON%Oh, humans. We did not think you would survive this long, and indeed it has been long since our services were called upon.%SPEECH_OFF%Lithe, hip-swaying creatures slip so lightly into the tent as though they were hardly more than the wind itself. Outside, you can hear the murmur of the rest of the company being overcome by the seductive beings. One walks toward you, her shape flashing between all the women of your life, testing your response, and when your heart warms it settles on a young lady that once broke your heart. The succubus falls atop you.%SPEECH_ON%Don\'t mind me, human, this is for you. Relax.%SPEECH_OFF%You let the pleasures wash over you.\n\n Immeasurable hours later you awake with your trousers down and %historian% in the corner rubbing his head.%SPEECH_ON%They were so wonderful, but the scroll\'s gone. I think it burned up after I said the words. Oh by the old gods do I wish I remember what they said!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Incredible.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Historian.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 75)
					{
						bro.improveMood(1.0, "Had a pleasurable supernatural experience");

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
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 10)
		{
			return;
		}

		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;

		foreach( t in towns )
		{
			local d = playerTile.getDistanceTo(t.getTile());

			if (d <= 8)
			{
				nearTown = true;
				break;
			}
		}

		if (nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_historian = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 3 && bro.getBackground().getID() == "background.historian")
			{
				candidates_historian.push(bro);
			}
		}

		if (candidates_historian.len() == 0)
		{
			return;
		}

		this.m.Historian = candidates_historian[this.Math.rand(0, candidates_historian.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"historian",
			this.m.Historian != null ? this.m.Historian.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Historian = null;
	}

});

