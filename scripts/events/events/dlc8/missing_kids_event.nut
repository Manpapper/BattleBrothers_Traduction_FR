this.missing_kids_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Cultist = null,
		Hedge = null,
		Killer = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.missing_kids";
		this.m.Title = "At %townname%";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_31.png[/img]{As you wander the streets of %townname%, a bevy of skinny guards suddenly emerge from an alley like a pack of rats and, like rats themselves, they are dangerously numerous. While you keep your head low, %anatomist% the anatomist can\'t help but offer a dimwitted stare and acquire their attention. The guards make eye contact and come over and as expected they start proffering their corruptions.%SPEECH_ON%Hey there, travelers. Word around town is that someone is killing kids. Now we\'ve reason to believe it\'s your strange fella here that\'s doing this awful, awful business.%SPEECH_OFF%The anatomist tries to defend himself, but you know that reason and rationality are not exactly on the table here. You ask the guards how much they want. They say.%SPEECH_ON%How about %blackmail% crowns, and we let this awful, awful kid killin\' business slide. Or we don\'t let it slide and beat the shite out of you both.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Alright, we\'ll pay the \'fine.\'",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "We aren\'t paying anything.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Hedge != null)
				{
					this.Options.push({
						Text = "Where is that hedge knight %hedgeknight% when you need him?",
						function getResult( _event )
						{
							return "Hedge";
						}

					});
				}

				if (_event.m.Cultist != null)
				{
					this.Options.push({
						Text = "Do you have something to say, %cultist% the Cultist?",
						function getResult( _event )
						{
							return "Cultist";
						}

					});
				}

				if (this.Const.DLC.Unhold && _event.m.Killer != null)
				{
					this.Options.push({
						Text = "%killer% the killer is always dodging guards, what would he do?",
						function getResult( _event )
						{
							return "Killer";
						}

					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_31.png[/img]{You pay them the gold. They take it and walk off laughing. %anatomist% explains that he never killed any kid, nor would he ever if there wasn\'t scientific value to be had in it. You close your eyes and ask him if he would kill a kid if there was scientific value in it. The anatomist scoffs.%SPEECH_ON%I\'d lay waste to them, sir.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Of course you would.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-750);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]750[/color] Crowns"
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_31.png[/img]{You tell them you\'ll have to count how much money you got. Looking down at your pockets you say.%SPEECH_ON%I think I got five.%SPEECH_OFF%The scrawniest of the guards steps forward saying \'five what?\' And you answer with a fist to his face. Before the man even hits the ground the rest of the guards are upon you both, kicking and punching and stomping. They run your pockets but you don\'t have a crown on you. Eventually they let up and stand off to the side, a crowd of peasants slowly gathering around the commotion. One guard slaps the other, indicating it is time to go. The lead guard stares down at you.%SPEECH_ON%Shite man, you sure can take a punch. Hope that beatin\' was worth it. C\'mon, let\'s get out of here.%SPEECH_OFF%Slowly, you get to your feet and then help %anatomist% up. He wipes the blood from his face. You\'re wise to an arse whoopin, but you figure this might be a first for the anatomist. The blood keeps leaking out of his nose and he keeps wiping. You tell him to lean his head back and lead him back to the wagon. The anatomist talks with a squeaky voice.%SPEECH_ON%It keeps bleeding. I know that this is what it was designed to do, but to see it and feel it in person...fascinating. Very fascinating.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "It gets old fast, trust me.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				local injury = _event.m.Anatomist.addInjury([
					{
						ID = "injury.broken_nose",
						Threshold = 0.0,
						Script = "injury/broken_nose_injury"
					}
				]);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Anatomist.getName() + " suffers " + injury.getNameOnly()
				});
			}

		});
		this.m.Screens.push({
			ID = "Hedge",
			Text = "[img]gfx/ui/events/event_96.png[/img]{%hedgeknight% the hedge knight suddenly rounds the corner. The guards take a step back. He\'s eating an apple with one hand while the other sets on the pommel of his weapon like an executioner\'s hand on his lever. He looks down at the guards, casting his eye upon one person at a time, judging each and finding them wanting. He takes another bite of the apple and turns to you.%SPEECH_ON%Is there a problem here, captain?%SPEECH_OFF%One of the guards quickly steps forward, smiling anxiously.%SPEECH_ON%Ah, no problem. We were just, uh, doing our due diligence in a certain matter.%SPEECH_OFF%The hedge knight tosses an apple core over his shoulder and then takes a long stretch, pieces of his armor grinding and clanking against each other. He nods.%SPEECH_ON%And how\'s that coming along?%SPEECH_OFF%The guards announce that they just finished. The hedge knight grins and says that if a man\'s time is spent in error, he should be compensated. Swallowing nervously, one of the guards forks over a purse of coins. He apologizes to you for wasting your time. The group of scrawny guards then beat a spooked, backpedaling retreat until they are gone. %hedgeknight% sighs. He says he was waiting on you to give the word. You ask him the word to do what. He produces another apple and crushes it in the ferocious squeeze of his hand. He thumbs one of the chunks into his mouth.%SPEECH_ON%What do you think?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ahh...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(150);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]150[/color] Crowns"
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Hedge.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Cultist",
			Text = "[img]gfx/ui/events/event_03.png[/img]{Before you can answer, a small bag flies between the parties and when it lands a pile of chicken bones spew out. Footsteps follow, and everyone turns to see who is making them. %cultist% the cultist comes forward and leans down and picks up one of the bones. He turns to the guards and says that no child here has gone missing, that their reports are lies. One of the scrawny guards cocks his head.%SPEECH_ON%And just who in the hells are you?%SPEECH_OFF%The cultist walks toward the guards, bones crunching under his boots. He leans into one\'s ear and begins to whisper. After the cultist is finished, the guard leans back.%SPEECH_ON%I am testing his patience?%SPEECH_OFF%The cultist nods and says.%SPEECH_ON%And to draw an end to that which is meant to be eternal will have such dire consequences for you that you will come to believe that to have lived at all was but a tremendous error, which it is, it all is.%SPEECH_OFF%The guards glance at one another. One offers crowns as though it were penitence. You gladly take the crowns and strangely enough they are warm to the touch. %cultist% turns around and nods, whispering something about the resolve of beings far beyond your understanding. You look down at the bones, but you don\'t remember the company getting any chickens, nor do you remember any chicken coops on your way in.%SPEECH_ON%Those look like-%SPEECH_OFF%The anatomist is talking a little too loudly about what those look like and you cut him off then and there, beating a hasty retreat from the street before anymore can come of this strange commotion.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s just get out of here.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local initiativeBoost = this.Math.rand(1, 3);
				_event.m.Cultist.getBaseProperties().Initiative += initiativeBoost;
				_event.m.Cultist.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Cultist.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiativeBoost + "[/color] Initiative"
				});
				this.World.Assets.addMoney(75);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]75[/color] Crowns"
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Cultist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Killer",
			Text = "[img]gfx/ui/events/event_20.png[/img]{You open your mouth to answer when suddenly a woman shrieks. Both parties look over to see a half-naked man twisting at the end of a rope, his neck shunted to an angle that is most incompatible with life. However, it wasn\'t the fall that killed him: his body has been mangled and mutilated, carved up with all manner of torturous devices. There\'s a figure atop a balcony looking down, a pair of wild eyes staring out the depths of a cowl and a smirk beneath them belying any notion of a guilty conscious. The guards shout and give chase. Laughing, the figure disappears from the balcony. You listen to the footrace between guards and murderer as it carries further into %townname%. Soon, all that you can hear is the occasional spatter of blood dripping off the corpse and the lapping of alley dogs who\'d come to lick it up. %anatomist% stares at it closely. He opens his mouth, but %killer% the killer on the run suddenly appears.%SPEECH_ON%Hey there captain. Thought you might enjoy these.%SPEECH_OFF%He hands over some armor attachments, the metals covered in blood. It need not take a genius to know where this item came from, but it is still yet quite nice and worth keeping. You tell him to clean it off and take it to inventory. The man nods. He takes a long great breath and lets it all out on a wide grin.%SPEECH_ON%Don\'t you just love life in the big city?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Well at least someone is living it up.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local attachmentList = [
					"mail_patch_upgrade",
					"double_mail_upgrade"
				];
				local item = this.new("scripts/items/armor_upgrades/" + attachmentList[this.Math.rand(0, attachmentList.len() - 1)]);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				this.World.Assets.getStash().add(item);
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Killer.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		if (this.World.Assets.getMoney() < 900)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() || t.getSize() < 2)
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomistCandidates = [];
		local cultistCandidates = [];
		local hedgeCandidates = [];
		local killerCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomistCandidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
			{
				cultistCandidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.hedge_knight")
			{
				hedgeCandidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.killer_on_the_run")
			{
				killerCandidates.push(bro);
			}
		}

		if (cultistCandidates.len() > 0)
		{
			this.m.Cultist = cultistCandidates[this.Math.rand(0, cultistCandidates.len() - 1)];
		}

		if (hedgeCandidates.len() > 0)
		{
			this.m.Hedge = hedgeCandidates[this.Math.rand(0, hedgeCandidates.len() - 1)];
		}

		if (killerCandidates.len() > 0)
		{
			this.m.Killer = killerCandidates[this.Math.rand(0, killerCandidates.len() - 1)];
		}

		if (anatomistCandidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getName()
		]);
		_vars.push([
			"blackmail",
			750
		]);
		_vars.push([
			"cultist",
			this.m.Cultist != null ? this.m.Cultist.getName() : ""
		]);
		_vars.push([
			"hedgeknight",
			this.m.Hedge != null ? this.m.Hedge.getName() : ""
		]);
		_vars.push([
			"killer",
			this.m.Killer != null ? this.m.Killer.getName() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Cultist = null;
		this.m.Hedge = null;
		this.m.Killer = null;
		this.m.Town = null;
	}

});

