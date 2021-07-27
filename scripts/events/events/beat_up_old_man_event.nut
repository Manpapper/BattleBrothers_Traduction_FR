this.beat_up_old_man_event <- this.inherit("scripts/events/event", {
	m = {
		AggroDude = null
	},
	function create()
	{
		this.m.ID = "event.beat_up_old_man";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 60 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_17.png[/img]{You come across an old man hobbling along the road. He settles himself against his walking stick and awaits your approach. His eyes are grey, but he tilts his head as though to see you with his ears.%SPEECH_ON%Chinking armor. Heavy footsteps. Steady breaths. More warriors for a land of war.%SPEECH_OFF%The man straightens up as though to say \'am I right?\'. You tell him that you\'re not here to harm him.%SPEECH_ON%So yes, I am right, as usual. It wouldn\'t be too much of a bother to run me through, though. My hearing\'s going and I suppose once it is gone so shall I be.%SPEECH_OFF%He pauses and turns his head.%SPEECH_ON%Did you say something?%SPEECH_OFF%You notice the man\'s got a nice jeweled ring on one of his bony fingers. %aggro_bro% sidles up to you.%SPEECH_ON%We could take that... you know, like taking a tart from a baby. A really blind, more helpless than usual baby.%SPEECH_OFF% | An old man with a walking stick is found resting against a stone wall. His hand caresses the stones with a familiar touch. He stares at you, a jeweled ring glistens on one of his bony fingers.%SPEECH_ON%Evening, sirs. What a fine day, no?%SPEECH_OFF%Getting a good look at him, you realize he is a blind man. | You come to an old man standing in the middle of the road, his body leaning against a walking stick. He\'s staring up at a road sign. He shakes his head.%SPEECH_ON%I know there is a sign here. I think %randomtown% is that way, if I recall correctly.%SPEECH_OFF%He turns to you grinning. His eyes glint white, blinded by old age. A very nice, very expensive looking jeweled ring glistens on one of his bony fingers.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Travel safely, old man.",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "That jeweled ring. Hand it over.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_17.png[/img]{You approach the man. His head tilts up.%SPEECH_ON%That is a quickened pace, stranger, but I do not hear the sound of a sword, instead...%SPEECH_OFF%With a sudden push you knock the man to the ground. He clutches his walking stick, the end of it pointed upward as though you might impale yourself on its rounded tip. You kick his hand out of the way and step on his wrist, bending down to take the ring.%SPEECH_ON%Put steel through my heart while you\'re at it, ya bastard!%SPEECH_OFF%You let off the man and hand him back his stick, even helping him to his feet.%SPEECH_ON%No hard feelings, old man.%SPEECH_OFF% | You kick the man down. He grunts as though you\'d just punted a pregnant boar. Turning over and clutching his stomach, he asks why, but you only kick him again to get him on his back. From there you easily rob him of the jeweled ring and make your leave. | The man smacks his old-man lips, that disgusting, crackling dry-mouth noise. In return, you rear back and throw a punch right into his stomach. Not seeing it coming, the elder eats it in full, blowing the air out of his lungs and bowling over. As he gasps for breath, you relieve him of the ring and leave. | The old man stands and leans against his walking stick. He raises his head up.%SPEECH_ON%Hmm, silence. The sound of ill intent between strangers. I stand in the dark, and you in the light, but where are we soon to be?%SPEECH_OFF%You kick the man\'s walking stick out from him and he topples over in a bumbling heap, his bony frame collapsing like a rickety hut. He rolls over and espouses some wisdom about violence between men. You boot him in the chest and tell him to shut up. The ring comes free of his finger with ease and you make your leave. | You crack your knuckles. The old man leans back.%SPEECH_ON%Surely violence is not the answer? This world doesn\'t need more of it.%SPEECH_OFF%With a swift punch, you knock him down and he crumples into a dry heaving mess. Taking the ring, you respond.%SPEECH_ON%I don\'t give a damn what this world needs or doesn\'t. I\'m my own world and you yours. They just happened to cross paths, that\'s all. And guess what, old man? My world is bigger.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Such is life.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-1);
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
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
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
			if (!bro.getBackground().isOffendedByViolence() && !bro.getBackground().isNoble() || bro.getSkills().hasSkill("trait.bloodthirsty") || bro.getSkills().hasSkill("trait.brute"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.AggroDude = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"aggro_bro",
			this.m.AggroDude.getName()
		]);
	}

	function onClear()
	{
		this.m.AggroDude = null;
	}

});

