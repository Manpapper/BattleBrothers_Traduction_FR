this.cultist_origin_finale_event <- this.inherit("scripts/events/event", {
	m = {
		Cultist = null,
		Sacrifice = null
	},
	function create()
	{
		this.m.ID = "event.cultist_origin_finale";
		this.m.Title = "During camp...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_33.png[/img]%cultist% enters your tent and a strong, brisk wind chases in after him, rearing up your scrolls and other notes. He walks forward, hands crossed before him, a rather priestly look to his approach.%SPEECH_ON%Sir, I\'ve been spoken to and it is a grave matter which I\'ve been given responsibility for.%SPEECH_OFF%You put your hand up and tell the man to be silent. Carefully, you reach out to each candle in the tent and snuff them out until one remains. You bring it to your face...",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Speak to me, Davkul.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_33.png[/img]Kneeling before the candle, you hold your hand over the flame and the fire comes to a standstill, pointing upright and unmoving. You\'ve seen icicles more animated than it. You stare into the glow and the tent melts away, slipping into the folds of an immense and immutable darkness. The cultist is gone. In his place is a black cloak, its arms to your shoulders, a slate of granite for a head, its edges chipped and cracking. It appears there is something behind this mask, behind this futile effort to keep your mind safe from its true visage. You reach out to the mask, but some invisible force stops you.%SPEECH_ON%In good time you shall see all that I am.%SPEECH_OFF%The voice is booming yet narrowed into a brutish whisper only for you to hear.%SPEECH_ON%I\'ll give you Death, mortal, and warmed in its comforts, Death shall be visited upon your enemies. %sacrifice% will not be lost, he will be with you always, this I promise you.%SPEECH_OFF%A whiteness snaps back over you, a rush of wind, tent flaps curling outward, the candle\'s flame tilting impossibly without going out, and a frigid coolness that has your first breath seen floating across the air. %cultist% is nowhere to be seen. You quickly get up and touch your face and skin, making sure that you are all that you\'re supposed to be. To your great disappointment, Davkul is gone and you are still you.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "The sacrifice must be made.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Absolutely not!",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_33.png[/img]Davkul would be most unhappy with your failure to obey, not that you feel any urge other than to do what is asked. You and the %cultist% go to %sacrifice%\'s tent. He leans up as though already expecting you and he sees the knife in the carriage of your party and nods at the simple sight of it. %cultist% kneels beside the man and you realize they\'ve already talked before this, that the question to you very well may have been a test of your devotion to Davkul. You are happy to have passed.\n\n%sacrifice% unbuttons his shirt and %cultist% pierces his chest as though he were putting a key into a lock, and he twists it all the same. The sacrifice gasps and tenses, for no devotion to Davkul can put aside the manner in which death may be permitted, which is in pain and suffering. But he smiles, and the light doesn\'t so much go out of his eyes as the darkness, a sort you haven\'t seen before, replaces it. And like that, he is gone.\n\n %cultist% gets to work on the still warm corpse, carving the flesh with rapid slices across the skin and hard cuts into the tendons. He pulls the chest apart. A black fog lingers with the blade\'s every move, and it seems to sway cheerily after its every move. When %cultist% is done, %sacrifice% has been turned into a slab of armor, flesh torn asunder and stretched, teeth for rivets, tendons for strappings, bones for pauldrons, a cuirass of absolute carnage. And it pulses and moves as though that manifested it still lived. %cultist% turns to you, his hands slopped red.%SPEECH_ON%Davkul awaits us all.%SPEECH_OFF%You nod and embrace your fellow comrade.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "It is done, and it is good.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Sacrifice.getImagePath());
				local dead = _event.m.Sacrifice;
				local fallen = {
					Name = dead.getName(),
					Time = this.World.getTime().Days,
					TimeWithCompany = this.Math.max(1, dead.getDaysWithCompany()),
					Kills = dead.getLifetimeStats().Kills,
					Battles = dead.getLifetimeStats().Battles,
					KilledBy = "Sacrificed to Davkul",
					Expendable = dead.getBackground().getID() == "background.slave"
				};
				this.World.Statistics.addFallen(fallen);
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Sacrifice.getName() + " has died"
				});
				_event.m.Sacrifice.getItems().transferToStash(this.World.Assets.getStash());
				this.World.getPlayerRoster().remove(_event.m.Sacrifice);
				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/armor/legendary/armor_of_davkul");
				item.m.Description = "A grisly aspect of Davkul, an ancient power not from this world, and the last remnants of " + _event.m.Sacrifice.getName() + " from whose body it has been fashioned. It shall never break, but instead keep regrowing its scarred skin on the spot.";
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain the " + item.getName()
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
					{
						bro.improveMood(2.0, "Appeased Davkul");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else
					{
						bro.worsenMood(3.0, "Horrified by the death of " + _event.m.Sacrifice.getName());

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
			Text = "[img]gfx/ui/events/event_33.png[/img]You feel this is a test. Not one to pass by sacrificing one of your men, but quite the opposite. Davkul may have sent false believers to see if you would do all that they say, simply because they say it. You do not know how you know this, you just know, which is the very sort of certainty a man should follow most. Just as you stand to go tell %cultist% of your decision, half the candles in the room suddenly blow out. Tendrils of smoke waft in the remaining gloom, a twisting haze through which, for but a moment, you swear you see a blackened visage fade out the tent\'s opening. You get the feeling that %cultist% already knows what choice you\'ve made. You stay in the tent and await Davkul\'s presence. When it is not felt, you simply light the candles again and speak to the emptied room.%SPEECH_ON%Davkul awaits us all.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "And with him, darkness.",
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
						bro.worsenMood(2.0, "Was denied the chance to appease Davkul");

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
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getTime().Days <= 150)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.cultists")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 12)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local sacrifice_candidates = [];
		local cultist_candidates = [];
		local bestCultist;

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
			{
				cultist_candidates.push(bro);

				if ((bestCultist == null || bro.getLevel() > bestCultist.getLevel()) && bro.getBackground().getID() == "background.cultist")
				{
					bestCultist = bro;
				}

				if (bro.getLevel() >= 11)
				{
					sacrifice_candidates.push(bro);
				}
			}
		}

		if (cultist_candidates.len() <= 5 || bestCultist == null || bestCultist.getLevel() < 11 || sacrifice_candidates.len() < 2)
		{
			return;
		}

		for( local i = 0; i < sacrifice_candidates.len(); i = ++i )
		{
			if (bestCultist.getID() == sacrifice_candidates[i].getID())
			{
				sacrifice_candidates.remove(i);
				break;
			}
		}

		this.m.Cultist = bestCultist;
		this.m.Sacrifice = sacrifice_candidates[this.Math.rand(0, sacrifice_candidates.len() - 1)];
		this.m.Score = cultist_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cultist",
			this.m.Cultist.getName()
		]);
		_vars.push([
			"sacrifice",
			this.m.Sacrifice.getName()
		]);
		_vars.push([
			"sacrifice_short",
			this.m.Sacrifice.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Cultist = null;
		this.m.Sacrifice = null;
	}

});

