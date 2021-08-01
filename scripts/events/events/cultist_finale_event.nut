this.cultist_finale_event <- this.inherit("scripts/events/event", {
	m = {
		Cultist = null,
		Sacrifice = null
	},
	function create()
	{
		this.m.ID = "event.cultist_finale";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_33.png[/img]%cultist% enters your tent and a strong, brisk wind chases in after him, rearing up your scrolls and other notes. He walks forward, hands crossed before him, a rather priestly look to his approach.%SPEECH_ON%Sir, I\'ve been spoken to and it is a grave matter which I\'ve been given responsibility for.%SPEECH_OFF%You ask the man who the hell he\'s talking about. The cultist bows forward as though the words weighed his tongue down just so.%SPEECH_ON%Davkul, sir.%SPEECH_OFF%Ah, of course, who else? You tell the man to explain what it is he needs. The man responds.%SPEECH_ON%No, not I, Davkul. Davkul is the one in need - and he needs blood, a sacrifice.%SPEECH_OFF%You tell the man the company can stop at the next town and get some chickens, lambs, or whatever else he needs if it\'s so important. %cultist% shakes his head.%SPEECH_ON%The blood of some impish beast? No, he demands the blood of a warrior. A true fighting spirit and he has trusted me to find a man of such import - and that I have.%SPEECH_OFF%The cultist straightens up, the tent\'s candlelight suddenly fickle and uneasy.%SPEECH_ON%Davkul demands the blood of %sacrifice%.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "And what if I do or don\'t agree to this insanity?",
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
			Text = "[img]gfx/ui/events/event_33.png[/img]Walking to a flickering candle, %cultist% holds his hand over the flame and the fire comes to a standstill, pointing upright and unmoving. You\'ve seen icicles more animated than it. He speaks as he stares into the glow.%SPEECH_ON%If we do this, Davkul will be most happy. If not, well, we shall see. Not even I know what may happen then.%SPEECH_OFF%You tell the cultist that he\'s asking you to kill one of your own men. He\'ll need to do better than that. Hearing this, he walks over and grabs you by the shoulders. The tent melts away, slipping into the folds of an immense and immutable darkness. The cultist is gone. In his place is a black cloak, its arms to your shoulders, a slate of granite for a head, its edges chipped and cracking. It appears there is something behind this mask, behind this futile effort to keep your mind safe from its true visage. A voice speaks, a guttural, booming voice that is yet narrowed into a brutish whisper only for you to hear.%SPEECH_ON%I\'ll give you Death, mortal, and warmed in its comforts, Death shall be visited upon your enemies. %sacrifice% will not be lost, he will be with you always, this I promise you.%SPEECH_OFF%A whiteness snaps back over you, a rush of wind, tent flaps curling outward, candleflames tilting impossibly without going out, and a frigid coolness that has your first breath seen floating across the air. %cultist% is nowhere to be seen. You quickly get up and touch your face and skin, making sure that you are all that you\'re supposed to be. The vision remains, though, and its pulsing imprint has left behind a grisly reality that what the cultist has suggested is something to be measured seriously.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Do what must be done.",
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
			Text = "[img]gfx/ui/events/event_33.png[/img]You decide to fall to the undeniable impression that Davkul would be most unhappy with your failure to obey. But %sacrifice% also has earned a departing word from you. Clearing up your face, you step out of your tent and go to speak to the man. Perhaps just hearing his voice will knock some sense into you before you step off the ledge into an insane void from which this act has no doubt been beckoned.\n\n When you get to his tent, you notice that its flap is already open and gently waving in the wind. You step inside and find the sellsword in bed, his blanket tossed over him. You take a seat, speak a few words, hoping deep down that he\'ll wake up in the middle of them.%SPEECH_ON%You\'ve been good, %sacrifice_short%, better than I could have asked for. A true brother to the %companyname% and the sort of fighter any captain would be proud to have.\n\nHey, don\'t leave me rambling here. I know you\'re awake, you lark.%SPEECH_OFF%You reach over to the blanket and draw it back. You jump to your feet and nearly knock the whole tent over. In the bed is not %sacrifice%, but a torso, its flesh torn asunder and stretched around armor made of unknown metal, teeth for rivets, tendons for strappings, bones for pauldrons, a cuirass of absolute carnage. %cultist% stands in the tent\'s opening.%SPEECH_ON%Davkul is most pleased and has graced us with an aspect of Death.%SPEECH_OFF%This... this is not what you were expecting. You don\'t even know what you were expecting, but this could never have been imagined or prepared for. What\'s done is done, and may the soul of %sacrifice% rest in peace. It is unlikely you ever will.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "May the old gods not be watching me on this night.",
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
					text = "Vous recevez the " + item.getName()
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
			Text = "[img]gfx/ui/events/event_33.png[/img]Despite the horror which you have just been witness to, you decide that %sacrifice% shall live. Just as you stand to go tell %cultist% of this, half the candles in the room suddenly blow out. Tendrils of smoke waft upward, a twisting haze through which, for but a moment, you swear you see a hard edged and angry visage turn and fade away. You get the feeling that %cultist% already knows what choice you\'ve made. You stay in the tent and light those candles back up.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Somewhere along the road, this company took a wrong turn.",
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
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getTime().Days <= 200)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() == "scenario.cultists")
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
			}
			else if (bro.getLevel() >= 11 && !bro.getSkills().hasSkill("trait.player") && !bro.getFlags().get("IsPlayerCharacter") && !bro.getFlags().get("IsPlayerCharacter"))
			{
				sacrifice_candidates.push(bro);
			}
		}

		if (cultist_candidates.len() <= 5 || bestCultist == null || bestCultist.getLevel() < 11 || sacrifice_candidates.len() == 0)
		{
			return;
		}

		this.m.Cultist = bestCultist;
		this.m.Sacrifice = sacrifice_candidates[this.Math.rand(0, sacrifice_candidates.len() - 1)];
		this.m.Score = 3;
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

