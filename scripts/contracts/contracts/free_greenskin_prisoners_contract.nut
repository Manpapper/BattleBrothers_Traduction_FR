this.free_greenskin_prisoners_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Dude = null,
		BattlesiteTile = null
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.free_greenskin_prisoners";
		this.m.Name = "Free Prisoners";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		if (this.m.BattlesiteTile == null || this.m.BattlesiteTile.IsOccupied)
		{
			local playerTile = this.World.State.getPlayer().getTile();
			this.m.BattlesiteTile = this.getTileToSpawnLocation(playerTile, 6, 12, [
				this.Const.World.TerrainType.Shore,
				this.Const.World.TerrainType.Ocean,
				this.Const.World.TerrainType.Mountains
			], false);
		}

		this.m.Payment.Pool = 1350 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
		local r = this.Math.rand(1, 2);

		if (r == 1)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else if (r == 2)
		{
			this.m.Payment.Completion = 1.0;
		}

		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Recherchez le champ de bataille %direction% de %origin% pour des indices",
					"Free any prisoners you find"
				];

				if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.IntroChance)
				{
					this.Contract.setScreen("Intro");
				}
				else
				{
					this.Contract.setScreen("Task");
				}
			}

			function end()
			{
				if (this.Contract.m.BattlesiteTile == null || this.Contract.m.BattlesiteTile.IsOccupied)
				{
					local playerTile = this.World.State.getPlayer().getTile();
					this.Contract.m.BattlesiteTile = this.getTileToSpawnLocation(playerTile, 6, 12, [
						this.Const.World.TerrainType.Shore,
						this.Const.World.TerrainType.Ocean,
						this.Const.World.TerrainType.Mountains
					], false);
				}

				local tile = this.Contract.m.BattlesiteTile;
				tile.clear();
				this.Contract.m.Destination = this.WeakTableRef(this.World.spawnLocation("scripts/entity/world/locations/battlefield_location", tile.Coords));
				this.Contract.m.Destination.onSpawned();
				this.Contract.m.Destination.setFaction(this.Const.Faction.PlayerAnimals);
				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 5)
				{
					this.Flags.set("IsSurvivor", true);
				}
				else if (r <= 10)
				{
					this.Flags.set("IsLuckyFind", true);
				}
				else if (r <= 15)
				{
					this.Flags.set("IsAccident", true);
				}
				else if (r <= 35)
				{
					if (this.Contract.getDifficultyMult() > 0.85)
					{
						this.Flags.set("IsScouts", true);
					}
				}

				r = this.Math.rand(1, 100);

				if (r <= 50)
				{
					this.Flags.set("IsEnemyCamp", true);

					if (this.Math.rand(1, 100) <= 20 && this.Contract.getDifficultyMult() < 1.15)
					{
						this.Flags.set("IsEmptyCamp", true);
					}
				}
				else
				{
					this.Flags.set("IsEnemyParty", true);
				}

				if (this.Math.rand(1, 100) <= 20)
				{
					this.Flags.set("IsAmbush", true);
				}

				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (!this.TempFlags.get("IsBattlefieldReached") && this.Contract.isPlayerAt(this.Contract.m.Destination))
				{
					this.TempFlags.set("IsBattlefieldReached", true);
					this.Contract.setScreen("Battlesite1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsScoutsDefeated"))
				{
					this.Flags.set("IsScoutsDefeated", false);
					this.Contract.setScreen("Battlesite2");
					this.World.Contracts.showActiveContract();
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Scouts")
				{
					this.World.Contracts.removeContract(this.Contract);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Scouts")
				{
					this.Flags.set("IsScoutsDefeated", true);
				}
			}

		});
		this.m.States.push({
			ID = "Pursuit",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Suivez les empreintes des Peaux-Vertes qui mènent en dehors du champ de bataille",
					"Libérez tous les prisonniers que vous croisez"
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;

					if (this.Flags.get("IsEmptyCamp"))
					{
						this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
					}
				}
			}

			function update()
			{
				if ((this.Contract.m.Destination == null || this.Contract.m.Destination.isNull()) && !this.Flags.get("IsEmptyCamp"))
				{
					this.Contract.setScreen("Battlesite3");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsAmbush") && !this.Flags.get("IsAmbushTriggered") && !this.TempFlags.get("IsAmbushTriggered") && this.Contract.m.Destination.isHiddenToPlayer() && this.Contract.getDistanceToNearestSettlement() >= 5 && this.Math.rand(1, 1000) <= 2)
				{
					this.TempFlags.set("IsAmbushTriggered", true);
					this.Contract.setScreen("Ambush");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsAmbushDefeated"))
				{
					this.Contract.setScreen("AmbushFailed");
					this.World.Contracts.showActiveContract();
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Ambush")
				{
					this.Flags.set("IsAmbushTriggered", true);
					this.World.Contracts.removeContract(this.Contract);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Ambush")
				{
					this.Flags.set("IsAmbushTriggered", true);
					this.Flags.set("IsAmbushDefeated", true);
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				this.Contract.setScreen("EmptyCamp");
				this.World.Contracts.showActiveContract();
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Revenez avec les prisonniers libérés à " + this.Contract.m.Home.getName()
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(null);
				}

				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success1");
					this.World.Contracts.showActiveContract();
				}
			}

		});
	}

	function createScreens()
	{
		this.importScreens(this.Const.Contracts.NegotiationDefault);
		this.importScreens(this.Const.Contracts.Overview);
		this.m.Screens.push({
			ID = "Task",
			Title = "Négociations",
			Text = "[img]gfx/ui/events/event_45.png[/img]{When you find %employer%, he\'s bending an ear to a peasant who is speaking desperately with a hoarse voice. Apparently, greenskins raided a nearby village and took off with prisoners. The nobleman immediately calls upon your services: get those people back... at a price, of course. | %employer% is staring at some maps when you enter his room. A few commanders stand at his side, using sticks as pointers to trace and mark the papered topography. When he sees you, the nobleman immediately beckons you close.%SPEECH_ON%I\'ve got a problem, sellsword. Greenskins have been raiding the lands, as I\'m sure you\'ve noticed, but lately we have gotten reports that they took some prisoners. We\'re not entirely sure where they went, but we know where they were last seen. If you go there, I think you could pick up clues as to where they are now. I hope this interests you, mercenary.%SPEECH_OFF% | You see %employer% and a peasant talking together. A few guards have the peasant by the arms, apparently having dragged him before the nobleman. You assume that some crime was committed, but instead this is simply how %employer% prefers to talk to the riff-raff. The layman\'s news has it that greenskins raided a local area and made off with some prisoners. They\'ve left enough clues it shouldn\'t be too hard to find them, were you willing to take the task, that is. | %employer% is found slouched in his chair.%SPEECH_ON%My people are losing faith in me. Word has it that the greenskins aren\'t just raiding villages, but taking prisoners, and I think that is somehow worse! But perhaps if someone could get those people back, my people would start trusting me again. What say you, sellsword, will you help find those poor lost souls? For proper pay, of course.%SPEECH_OFF% | %employer% is found talking to one of his commanders.%SPEECH_ON%We\'ll get them back, don\'t you worry.%SPEECH_OFF%Seeing you, the nobleman quickly informs you that there was a large battle with greenskins and, per reports, prisoners were taken. The commander steps forward, thumbs in his belt, a large sword clanking at his side.%SPEECH_ON%Sellsword, it\'d be a great service if you could bring those men back.%SPEECH_OFF% | %employer% is arguing with one of his commanders.%SPEECH_ON%Look, we can\'t afford to send out anymore men.%SPEECH_OFF%The commander points at you.%SPEECH_ON%What about him?%SPEECH_OFF%You\'re quickly informed of the situation: there was a large battle with greenskins %direction% from here and prisoners were taken. %employer% doesn\'t have enough men to go out looking for them and needs a man of your flexibility to do the job. | You find %employer% looking at a map. He points at a spot.%SPEECH_ON%%direction% of here was a large battle with some greenskins. We have reason to believe they took prisoners - and I have reason to believe you can get them back.%SPEECH_OFF% | A guard wobbles to you on crutches. His leg is leaking all over the stone floors.%SPEECH_ON%Hey, you\'re with the %companyname%, right? %employer% told me to meet you.%SPEECH_OFF%He explains that his men clashed with greenskins %direction% of here and that they possibly made off with a group of prisoners. You ask the man why he isn\'t getting care.%SPEECH_ON%I, uh, ran from the field. This is my punishment. Don\'t matter anyhow, the apothecary says I\'ll be dead within the month. See this? Fair bit ugly, no?%SPEECH_OFF%He gingerly lifts his leg up. Green pustules are bubbling up autour de bandages. It is quite ugly. | %employer% is found trying to get an ink bottle back from his dog.%SPEECH_ON%You swallow that yer dead, why don\'t you understand that you stupid mutt?%SPEECH_OFF%The nobleman sees you and straightens up.%SPEECH_ON%Sellsword! It\'s good seeing you for these are truly dire times. There was a battle with greenskins %direction% of here and my commanders report that the savages made off with prisoners! I need a man of your services to help get those men back.%SPEECH_OFF%While you mull it over, the dog scarfs down the ink bottle and immediately begins to gag. It comes back up in a stream of blackened vomit. A quill pen gently glides astride the puke. %employer% incredulously raises his hands.%SPEECH_ON%I spent an hour looking for that! It was my favorite you damned dog.%SPEECH_OFF% | You find %employer% unfurling a scroll. He reads it dutifully as a pensive scribe looks over his shoulder. The nobleman slams the paper onto his desk and waves you in.%SPEECH_ON%There was a large battle with greenskins %direction% of here and those savages took prisoners! Prisoners, can you believe it?%SPEECH_OFF%Before you can answer, %employer% continues on.%SPEECH_ON%Look, I don\'t have men to spare, but if it\'s true that the greenskins took prisoners, then perhaps a man of your capabilities could help get them back?%SPEECH_OFF% | One of %employer%\'s commanders meets you outside the door to his room. He hands you a scroll with instructions written on it. Per the report, a large battle %direction% of here ended up with greenskins taking prisoners. %employer% is interested in getting those men back, but doesn\'t have soldiers to spare with which to rescue them. The commander crosses his arms.%SPEECH_ON%If you wish to negotiate, my liege has delegated me the power to do so.%SPEECH_OFF% | You find %employer% kicking a cat around his room, chasing it with his foot wherever he can until the feline takes to the ceiling, clutching tightly to the top of a curtain stalk. The nobleman stares up at it.%SPEECH_ON%I do not think I could ever find the words to state how much I hate that damned thing.%SPEECH_OFF%He turns to see you.%SPEECH_ON%Mercenary! You are a sight for sore eyes! I need something done, and no it\'s not about that damned critter. My soldiers got into a battle with greenskins %direction% of here. Reports state that the savages took prisoners which means they could possibly be taken back. And I think you, sir, are the man for the job.%SPEECH_OFF%The cat mewls and stoops on its haunches. %employer% wheels around, pointing a finger.%SPEECH_ON%I want you to jump down here! I want you to!%SPEECH_OFF% | There\'s a group of commanders standing around %employer%. There\'s also a man\'s head on the desk before them. %employer% looks at you.%SPEECH_ON%A detachment of soldiers made contact with greenskins %direction% of here. They lost, if you couldn\'t tell. They also took prisoners and, if that\'s true, I have a keen interest in getting those men back! I think you\'re the perfect man for the job, sellsword, so what say you?%SPEECH_OFF% | A skinny kid stands beside %employer%, drawing up a map and explaining a series of events he witnessed with his own eyes: a detachment of soldiers clashed with greenskins %direction% of here and lost. The savages then took prisoners and made off with them. %employer% turns to you.%SPEECH_ON%Well, if what this scrawny peasant says is true, then we need to get those men back. Sellsword, what say you? Are you interested in rescuing my soldiers?%SPEECH_OFF% | You find %employer% speaking to a weeping commander.%SPEECH_ON%So, let me get this straight. %direction% of here you ran into a group of greenskins, lost, fled, and watched some of your men be taken prisoner?%SPEECH_OFF%The commander nods. %employer% waves his hand at some guards.%SPEECH_ON%Dishonorable cowardice will find no reward in these halls, take him away! And you, sellsword! I need a man of stronger constitution to go out there and get those prisoners back!%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{J\'imagine que vous allez payer chère pour ça. | Parlons argent. | Tout peut être fait si la paie est juste.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Ça ne vaut pas le coup. | On est demandé autre part.}",
					function getResult()
					{
						this.World.Contracts.removeContract(this.Contract);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Battlesite1",
			Title = "À the battle site...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Flies so loud you hear them before you can even smell what they\'re busying themselves on. A horde of insects descended upon a field of filth, a plague-spot of horror where man and greenskin clashed and there was desperation for winning yet everyone had lost. You wave your way in through the fog of flies and order the %companyname% to start looking for survivors or clues. | Dead piled upon dead. Horses here and there. One scampering into the distance, bucking and wild. The smell of insides turned out. Every footstep into a bloody puddle. %randombrother% comes up with a cloth to his nose.%SPEECH_ON%We\'ll start looking for clues, sir, but it\'s going to be rough.%SPEECH_OFF% | Smoke and blood and earth turned to mud. You step about the battlefield, ordering the mercenaries to fan out and look for clues. %randombrother% stares at a greenskin impaled at the end of a broken pitchfork, the orc itself stabbing its killer in the skull with a rusted blade. He shakes his head.%SPEECH_ON%Right. \'Clues\', as if we have to wonder what really happened here.%SPEECH_OFF%You remind him that the greenskins made off with prisoners and the %companyname% is there to rescue them. | %randombrother% looks at the battlefield.%SPEECH_ON%Are you sure there were any survivors to haul off?%SPEECH_OFF%Indeed, it appears a great ball of bodies had smashed the earth and rendered it bloody and unfamiliar. Corpses twisted and stiffened in so many ways, orcs with maws open in eternal growls, men and women torn asunder. Horses buried amongst the corpses with their legs scissored into the air like crooked totems of bestial fury. You\'re not sure if prisoners were taken from here or not, but you order the %companyname% to start looking. | Prisoners taken from here would be like demons dragged out of the hells themselves. Looking over mounds of dead with their limbs so tangled and bone-jutting, you can\'t possibly imagine how anyone would have survived. It is as if a great crowd of men and beasts stood together, and a greater boulder made of destruction plowed into them all and the remnants were the scatterings you find before you. Very few can be said to be in whole. %randombrother% takes a cloth to his face and looks down at it, waving flies out of his face.%SPEECH_ON%Well, I guess we\'ll start looking for tracks. Can\'t, uh, promise anything though.%SPEECH_OFF% | Looking for tracks here would be like finding a needle in a haystack of dismembered corpses. %randombrother% puts his hands to hips and laughs incredulously.%SPEECH_ON%Someone survived this shitshow, much less saw fit to take prisoners?%SPEECH_OFF%You shrug and order the %companyname% to start searching for clues. | You get the sense that this place used to be a serene location for runaway lovers and playful children. Now the earth has been turned to mud and the dead littered across it as numerous as the footprints they created in their chaotic finalities. %randombrother% wipes his brow.%SPEECH_ON%Ain\'t that some shit. Well, I guess we\'ll poke around and see if we can find any tracks or clues.%SPEECH_OFF% | You come across the battlefield. %randombrother% leans back, laughing at the absolute horror before him.%SPEECH_ON%The gods, what on earth? You gotta be kidding me!%SPEECH_OFF%First there was a battle. Men and beasts. Raging desperation. The dying took plenty of company. Then there was the rain. Trampled earth turned to mud. Bloodied fields into a literal bloodbath. And now you, the mercenaries, the witnesses, mucking through frothing crimson, taking into summation a remnant of total ruination. You shake your head and start order the men around.%SPEECH_ON%We\'re here for clues. Look for any tracks leading away. Whatever survived this took prisoners.%SPEECH_OFF% | You don\'t really see bodies so much as parts. A litter of hints that, one day and at one time, a collection of men and beasts met here, and in their savagery they displaced any notion that the warriors were ever whole. %randombrother% tilts a boot up at the end of a stick and a foot comes sliding out. He shakes his head.%SPEECH_ON%Alright, we can start looking for tracks, but I\'ll damned shocked if anyone survived here, much less saw fit to take prisoners.%SPEECH_OFF% | %randombrother% looks at the battlefield.%SPEECH_ON%Damn.%SPEECH_OFF%You\'ve found the remnants of a fight, a bunch of ruined greenskins and men bundled together in a twisting, bloody ceremony. Horses stands off to the side, poking their heads at the scene with conflicted, ear pinning curiosity. They scatter as your men start picking through the scene looking for clues. You bark an order out.%SPEECH_ON%Remember, the greenskins took prisoners! Look for tracks, men.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Search everywhere!",
					function getResult()
					{
						if (this.Flags.get("IsAccident"))
						{
							return "Accident";
						}
						else if (this.Flags.get("IsLuckyFind"))
						{
							return "LuckyFind";
						}
						else if (this.Flags.get("IsSurvivor") && this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
						{
							return "Survivor";
						}
						else if (this.Flags.get("IsScouts"))
						{
							return "Scouts";
						}
						else
						{
							return "Battlesite2";
						}
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Battlesite2",
			Title = "À the battle site...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{%randombrother% has found a set of tracks leading away from the site. The %companyname% should follow them! | A set of tracks has been found trailing away from the battlefield. There are smaller human prints amongst larger, orc ones. You\'ll likely be able to find the prisoners if you follow them. | %randombrother% crouches low to the earth and beckons you over. He points at some impressions in the ground.%SPEECH_ON%What do those look like, sir?%SPEECH_OFF%You see sets of smaller boot-prints and much, much larger footprints. There are also series of little prints that dote along the side. You point and assess each in turn.%SPEECH_ON%Human, orc, goblin. I say if we follow these we may just find our prisoners yet.%SPEECH_OFF% | You stumble upon, or rather into, a large set of footprints. Judging by the fat toes and bootless shapes, these are orc prints. However, alongside them are tracks you can instantly recognize. %randombrother% comes up.%SPEECH_ON%Looks like that\'s our scent, sir. We follow those and the prisoners shan\'t be too far off from sweeter days.%SPEECH_OFF% | You crouch down and look at a series of tracks. Human, orcs, goblins. All fresh, all leading away from the battlefield. If followed, they\'ll likely lead to the prisoners you\'re after. | The footprints of a mass of orcs and goblins leads away from the battlefield. Leading up their sides are a series of human prints, all very fresh. %randombrother% spits and nods.%SPEECH_ON%That there is what we\'re looking for. We follow those and we just might find those prisoners yet. I mean, they\'re all probably dead as my grandma and she died real hard in a rock slide, but it\'s still worth lookin\', I suppose.%SPEECH_OFF% | %randombrother% announces a most relevant finding: a series of footprints, man and beast, leading away from the battlefield. If the %companyname% were to follow them, then finding the prisoners shan\'t be too far off. | A man with a pitchfork comes yonder, wheeling the fork stake-side into the earth as he tentpoles himself up a hill. He yells at you to approach which you slowly do. The man grins as you come near.%SPEECH_ON%Yer lookin\' fer the prisoners, aintcha?%SPEECH_OFF%He turns broomstraw between teeth and where teeth should be. He points.%SPEECH_ON%There be tracks in that yonder mud path. Dunno why the savages left signs of their coming and goings, but I guess that\'s why they call them savages, huh.%SPEECH_OFF%You thank the farmer for his help and, just as he said, soon find tracks leading away from the battlefield. The %companyname% should follow them to find the prisoners. | While searching through the battlefield, %randombrother% is spooked by a kid who jumps out from a corpse with his hands splayed at the sides of his head like some sickly plant come to carnivorous life. The sellsword draws his weapon.%SPEECH_ON%You\'ll pay for that you little shite!%SPEECH_OFF%You stop the mercenary and ask the kid what he\'s doing. The little guy shrugs.%SPEECH_ON%Playing. Say, you wouldn\'t be interested in knowing where the greenies went off to, would ya?%SPEECH_OFF%Of course you are. The kid leads you to a series of tracks, human, orc, and goblin. All fresh. You tell the kid to go on home, it isn\'t safe out here. He rolls his eyes.%SPEECH_ON%{Gosh, that\'s a mighty fine \'thanks\' you given me, mister. | Well shite, mister, you\'re welcome. I thought I was out here to have some fun, but I guess my real purpose was to wait fer you to show up. | Oh that\'s great, I thought I\'d ran off from m\'mother but here she be anyway gatdammit.}%SPEECH_OFF% | You\'re beginning to lose hope of finding anything when a young woman comes by with a basket. She\'s picking up cloth rags from the dead, wringing the blood out as she goes. You ask if she saw anything. She nods.%SPEECH_ON%Yeah of course I saw something, I got eyes, don\'t I? I also got somethin\' in the noggin\' and it\'s been well gestured that you, sir, are looking for the prisoners those green bastards went off with.%SPEECH_OFF%You nod and ask where they went. She points down a hill.%SPEECH_ON%See that trail? In it are tracks. The savages left plenty of notice of where they were going. I wouldn\'t follow them, personally, but you look the sturdy sort. Say, what kind of cloth is that?%SPEECH_OFF%She points at the banner of the %companyname%. You shrug. She shrugs too.%SPEECH_ON%Well, it\'s nice. If you see anything like that out here, you come and tell, alright? I\'m making a dress for m\'wedding.%SPEECH_OFF% | A man comes stomping up a path, swinging his legs like a soldier while a set of dead fish dangle from his hip. He stops at the sight of you.%SPEECH_ON%Lemme guess, yer lookin\' for where those prisoners went off to, right?%SPEECH_OFF%You nod and ask if he\'s seen where they went off to. He shakes his head, but points at his feet.%SPEECH_ON%No sir, not exactly. But there be tracks right here. See, human and greenskin. That might have something to do with them don\'t ya think?%SPEECH_OFF%Indeed it does. You order the %companyname% to ready for a march. | The battlefield doesn\'t have any clues, but the area just outside it does: you find a series of tracks staggered with the prints of men and greenskins. No doubt they will lead to the prisoners, or at the very least those who took them. | %randombrother% calls you over. At his feet are a series of large footprints and a couple of increasingly smaller ones. They combine into formations that trail out from the battlefield. The mercenary glances at you.%SPEECH_ON%Sure as shite that those are the prisoners there, and the orcs there, and them little ones doting along are gobbos.%SPEECH_OFF%You nod and yell out to the %companyname% to prepare to follow the tracks. | %randombrother% finds a few tracks laying just outside the battlefield. You come over to inspect and he points to their differing sizes in turn.%SPEECH_ON%I think those belong to orcs, those be goblins, and those, those are the prisoners we\'re looking for.%SPEECH_OFF%You agree with his assessment. If the %companyname% follows these tracks they\'ll likely find the prisoners and their captors.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Let\'s get moving!",
					function getResult()
					{
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
						local playerTile = this.World.State.getPlayer().getTile();
						local nearest_goblins = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getNearestSettlement(playerTile);
						local nearest_orcs = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getNearestSettlement(playerTile);
						local camp;

						if (nearest_goblins.getTile().getDistanceTo(playerTile) <= nearest_orcs.getTile().getDistanceTo(playerTile))
						{
							camp = nearest_goblins;
						}
						else
						{
							camp = nearest_orcs;
						}

						if (this.Flags.get("IsEnemyParty"))
						{
							local tile = this.Contract.getTileToSpawnLocation(playerTile, 10, 15);
							local party = this.World.FactionManager.getFaction(camp.getFaction()).spawnEntity(tile, "Greenskin Horde", false, this.Const.World.Spawn.GreenskinHorde, 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
							party.getSprite("banner").setBrush(camp.getBanner());
							party.setDescription("A horde of greenskins marching to war.");
							party.setFootprintType(this.Const.World.FootprintsType.Orcs);
							this.Contract.m.UnitsSpawned.push(party);
							party.getLoot().ArmorParts = this.Math.rand(0, 25);
							party.getLoot().Ammo = this.Math.rand(0, 10);
							party.addToInventory("supplies/strange_meat_item");
							this.Contract.m.Destination = this.WeakTableRef(party);
							party.setAttackableByAI(false);
							party.setFootprintSizeOverride(0.75);
							local c = party.getController();
							c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
							local wait = this.new("scripts/ai/world/orders/wait_order");
							wait.setTime(15.0);
							c.addOrder(wait);
							local roam = this.new("scripts/ai/world/orders/roam_order");
							roam.setPivot(camp);
							roam.setMinRange(5);
							roam.setMaxRange(10);
							roam.setAllTerrainAvailable();
							roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
							roam.setTerrain(this.Const.World.TerrainType.Shore, false);
							roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
							c.addOrder(roam);
						}
						else
						{
							this.Contract.m.Destination = this.WeakTableRef(camp);
							camp.clearTroops();

							if (this.Flags.get("IsEmptyCamp"))
							{
								camp.setResources(0);
								this.Contract.m.Destination.setLootScaleBasedOnResources(0);
							}
							else
							{
								this.Contract.m.Destination.setLootScaleBasedOnResources(120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());

								if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
								{
									this.Contract.m.Destination.getLoot().clear();
								}

								camp.setResources(this.Math.min(camp.getResources(), 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
								this.Contract.addUnitsToEntity(camp, this.Const.World.Spawn.GreenskinHorde, 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
							}
						}

						this.Const.World.Common.addFootprintsFromTo(playerTile, this.Contract.m.Destination.getTile(), this.Const.OrcFootprints, this.Const.World.FootprintsType.Orcs, 0.75, 10.0);
						this.Contract.setState("Pursuit");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Battlesite3",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_53.png[/img]{The greenskins defeated, you head into their camp to find the prisoners caged and blindfolded. You order the mercenaries to start freeing them. Thinking themselves already dead, most of the prisoners break down in tears and thank you for rescuing them. All in a day\'s work, really. | The greenskins have been defeated and you quickly head into their camp. You find the prisoners in a tent, huddled together with no clothes. The freedmen can hardly speak, but their eyes tell a lot about the horrors they\'ve experienced. %randombrother% goes and gets some blankets to cover them up for the return trip to your employer, %employer%. | The greenskins have been dealt with, now you and your men start picking through their abandoned camp. You immediately hear people screaming from a tent. %randombrother% opens the flap to see a goblin waving a hot iron in front of a group of huddled, naked men. The sellsword cuts the creature\'s head off in a single swipe before it can even realize the reversal in its fortunes. The prisoners cry out, thanking you for the rescue. Your employer, %employer%, should be most pleased that at least some of his men will be coming home. | The greenskins defeated, you and the %companyname% rush into their encampment. There you find a goblin poking and prodding a man who has died from torture. %randombrother% grabs the unwitting goblin and puts a blade through the back of its skull. You follow blood trails into a nearby tent to find a group of blindfolded men huddled together. They skirt away from your voice, but you quickly make it clear that you\'re here to help them. The poor souls have been through a lot. Returning them to your employer, %employer%, and their homes should make for a good recovery. | Any thought the greenskins\' had about coming out ahead in that fight have been put to rest: those savages are quite thoroughly dead.\n\nYou order the men to start searching through their encampment to try and find the prisoners. It isn\'t long until %randombrother% finds the men huddled underneath a tent. They\'ve been beaten and tortured, but they\'ll live. A few thank you, and most others thank the old gods. Damn deities stealing your thunder yet again. Anyway, your employer, %employer%, will be most pleased. | The %companyname% dispatches the greenskins with ease and quickly rushes into their abandoned encampment. The horrors there are beyond comprehension. Men skewered on spits, others tentpoled into the sky on the ends of enormous stakes. Thankfully, there is still light in all this dark: the prisoners you were looking for are found. They\'re badly beaten, but they are alive. | The greenskins have been defeated. You venture into their encampment to find horrors glistening freshly red. Flayed figures strung up against racks of twisting thorn and tree branches. Grey bodies disemboweled, their gaunt and stretched faces still witnessing a most grotesque undoing. More men are found in a shallow trench, bound face down into frothy waters, great boulders placed upon their backs so they drowned with breath but an inch away.\n\nNot only are you worrying that there are no survivors, a part of you is hoping there are none. Such horrors were not meant to be carried forward. Unfortunately, %randombrother% beckons you over to a tent. Inside, a few prisoners huddle together, naked and shrinking from your presence. You order the %companyname% to get the men dressed, fed, and watered for the return trip to your employer, %employer%. | The %companyname% defeats the greenskins with relative ease and ducks into the savages\' encampment. There you find humans made into holy totems, great obelisks of glistening bone and cairns of tilted skulls. %randombrother% calls you over to one of the goatskin tents. You rush over to find a few prisoners there, each squared away into a cage of tightly folded metal barbs. Each man is carefully freed, and each man opens up about the horrors which they had endured. You ensure the men that they will be returned to their families. | Having defeated the greenskins, you quickly rush into their camp to find the prisoners. They are seen latched to a long black chain. A frail orc with crooked eyes and malformed hands is trying to make off with the men. %randombrother% rushes forth and clubs the greenskin over the back of the head. It drops to the ground and rolls over onto a bulbous back. The misshapen and deformed creature calls out in an unlearned shout, some retardation of language beyond even the brutish orcish tongue. %randombrother% hesitates a moment, the orc\'s eyes only witness to a world it never understood, and then the man grits his teeth and stoves the creature\'s head in.\n\nYou free the prisoners who explain that they were about to be carted off by what might have been the tribe\'s idiot. Either way, they\'re saved now and %employer% will be most pleased to have them back! | The greenskins have been defeated and the prisoners are quickly saved from the savages\' encampment. Each prisoner has a story of horror to tell, even the ones who speak not a word. Your employer, %employer%, will be most pleased. | Your employer, %employer%, probably didn\'t trust that this would happen, but after defeating the greenskins and driving into their encampment you manage to save the prisoners! They\'re not in the best health, but seeing the %companyname% instead of an orc with a firebrand or an executioner\'s axe has definitely lifted their spirits. | After defeating the greenskins, the %companyname% quickly rushes to the savages\' encampment. There you find the prisoners tethered by ropes to a bear-baiting pole. One dead bear is in the mud, along with a couple of horrifically mauled men. The survivors, who apparently killed the animal with their bare hands, should be taken back to your employer in %townname% as soon as possible. | The %companyname% triumphs over the greenskins and rushes to find the prisoners in the savages\' encampment. You\'re not sure if the soldiers are fit to ever fight again, but hopefully your employer, %employer%, treats them with care anyway.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We have what we came for. Time to Retournez à %townname%!",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Scouts",
			Title = "À the battle site...",
			Text = "[img]gfx/ui/events/event_49.png[/img]{While footing autour de corpses in search of clues, you\'re suddenly set upon by a group of greenskins! They were probably coming back to loot the battlefield. You quickly order the men into formation as the savages do the same. | A greenskin scouting party intending to loot the battlefield has instead stumbled upon the %companyname%. Prepare for battle! | While sweeping the area for clues, a small group of greenskins walks into the %companyname%. They were probably just coming back for the loot, but now you\'ll be adding them to the piles of corpses! | The %companyname% is searching for clues when a greenskin looting party returns to the battlefield! | You flip a body over and a goblin is leering at you. You try and kick that body over, too, except it growls and grabs ahold of your foot. It\'s not dead! Looking up, you see an equally surprised group of greenskin looters staring back at you. The goblin screams and retreats and you also quickly fall back, ordering the %companyname% to get into formation.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To arms!",
					function getResult()
					{
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "Scouts";
						p.Music = this.Const.Music.GoblinsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						local nearest_goblins = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getNearestSettlement(tile);
						local nearest_orcs = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getNearestSettlement(tile);
						local camp;

						if (nearest_goblins.getTile().getDistanceTo(tile) <= nearest_orcs.getTile().getDistanceTo(tile))
						{
							camp = nearest_goblins;
						}
						else
						{
							camp = nearest_orcs;
						}

						p.EnemyBanners.push(camp.getBanner());
						p.Entities = [];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.GreenskinHorde, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Survivor",
			Title = "À the battle site...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{%randombrother% is picking through the bodies when he jumps back.%SPEECH_ON%Sir! We got a live one here!%SPEECH_OFF%You rush over to see a man clambering out of a bushel of limbs. He shakily comes to stand, a blood soggy face crinkling against the light. The man states that he was here in the fight - and that he has every intention to end it. Apparently, he\'ll join the %companyname% free of charge! | While searching through the remains of the battlefield, you suddenly hear a man screaming from beneath the bodies. %randombrother% starts shucking corpses off until you find a man\'s face grinning back up at you.%SPEECH_ON%By the olds gods, I thought I\'d die down there.%SPEECH_OFF%You ask if he fought in the battle which he says he did. He sticks a hand out and you pull him out of the pile. He comes out scraping gore off his shoulders. Spotting the %companyname% banner, he asks if you got room for one more.%SPEECH_ON%I got a bit of unfinished business, I\'m sure you understand.%SPEECH_OFF% | You were under a misapprehension that there was nothing here but the dead: %randombrother% has found a survivor buried beneath the mounds of bodies. You go to meet him, a warrior who stands wobbly atop the corpses of the slain. He slims his eyes as he gets his bearings.%SPEECH_ON%Ah, I recognize that sigil. You\'re the %companyname%. Well, gentlemen, I\'ve little else here for me and I\'ve never been too keen on cleaning messes. What say I join you fellas?%SPEECH_OFF% | A survivor is found poking his head out from the armpit of an orc warrior. He\'s gasping for air as %randombrother% and you help drag him out. %randombrother% gives him a drink of water and you ask if there are any other survivors. He shrugs.%SPEECH_ON%Well, they were screaming for a time, but now they ain\'t. Say, are you with the %companyname%?%SPEECH_OFF%The man wipes his mouth and throws a hand to the company banner. You nod. He nods back and takes another drink.%SPEECH_ON%Well, mercenaries, there ain\'t fark all for me here. Not anymore. I hope it wouldn\'t be too much to ask, but perhaps I could join your company?%SPEECH_OFF% | You\'ve found a survivor! A man who comes climbing out of the mound of corpses like a worm wriggling forth from a basket of rotten apples. He wipes blood and grey gore from his face and laughs.%SPEECH_ON%I stayed down there thinking the greenskins would come back, but you fellas are a sight for sore eyes, goodness!%SPEECH_OFF%As %randombrother% hands him water to drink, you ask him if there were other survivors. He nods.%SPEECH_ON%Yeah, and they got taken prisoner, the old gods know what became of them. Say, if that\'s the %companyname% sigil I\'m seeing, would you mind if I joined the company? I\'m sure you noticed, but there ain\'t fark all for me here.%SPEECH_OFF% | A man stands up out of the dead as though he had been expecting you all along. %randombrother% jumps back in a fright, drawing his weapon. The survivor gives a friendly wave.%SPEECH_ON%I must admit, I didn\'t expect your lot. I thought for sure the greenskins would be the ones returning to loot what\'s left here. Say, is that the %companyname% banner you\'re flying there?%SPEECH_OFF%You tell him it is. He claps his hands and walks forward, stumbling over skulls and dismembered limbs and sliding his feet down blood-filled mudholes.%SPEECH_ON%What luck! I\'m in need of a new outfit and if it wouldn\'t be a bother, I\'d love to join our company!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Welcome to the %companyname%!",
					function getResult()
					{
						this.World.getPlayerRoster().add(this.Contract.m.Dude);
						this.World.getTemporaryRoster().clear();
						this.Contract.m.Dude.onHired();
						this.Contract.m.Dude = null;
						return "Battlesite2";
					}

				},
				{
					Text = "Not going to happen. Get out of here.",
					function getResult()
					{
						this.World.getTemporaryRoster().clear();
						this.Contract.m.Dude = null;
						return "Battlesite2";
					}

				}
			],
			function start()
			{
				local roster = this.World.getTemporaryRoster();
				this.Contract.m.Dude = roster.create("scripts/entity/tactical/player");
				this.Contract.m.Dude.setStartValuesEx(this.Const.CharacterVeteranBackgrounds);
				this.Contract.m.Dude.setHitpointsPct(0.6);

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).setArmor(this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).getArmor() * 0.33);
				}

				if (this.Contract.m.Dude.getTitle() == "")
				{
					this.Contract.m.Dude.setTitle("the Survivor");
				}

				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Accident",
			Title = "À the battle site...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Picking through a battlefield is not the safest of businesses and that axiom comes to fruition when %hurtbro% hurts himself. | %hurtbro% has slipped and fallen onto a pile of weapons. Naturally, he got a little hurt. | Unfortunately, %hurtbro% slipped on the bloody mud and fell face first onto an orc warrior\'s opened maw. He\'s suffered some injuries. | Battlefields are dangerous long after the fighting is over: %hurtbro% has slipped and fallen. Just a little banged up, he\'ll be fine. | You knew one of these idiots would slip eventually: %hurtbro% put his foot on a shield which promptly slid down a mound of corpses. He skidded right into a pile of weapons and suffered some obvious consequences for doing that. | %hurtbro% yells out.%SPEECH_ON%Hey, watch this!%SPEECH_OFF%He jumps on a shield and starts sledding it down a mound of corpses. Unfortunately, a huge orc hand clips the shield and sends him spinning a circle. He flies backward off the shield and lands on a pile of weapons. He moans in pain. %randombrother% calls out.%SPEECH_ON%{I seen what you did there. | Ain\'t no ladies to impress around here ya moron.}%SPEECH_OFF% | %hurtbro% picks up a rusted orc blade and tries his hand at using it. Unfortunately, he trips on its former owner and cuts himself in the fall. The idiot will heal with time. | You watch as %hurtbro% is picking up and testing various orc weapons. For just one moment you turn away and the damned fool hurts himself. You turn back to see him keeled over and moaning in pain. It\'s not serious, but damn you wished these idiots would be more careful. | Despite your telling the men to be careful, %hurtbro% manages to slip and fall onto the face of an orc, which might as well have been him slipping and falling onto an actual weapon. He\'s hurt, but he\'ll survive. | %hurtbro% picks up a small goblin and plays around as though it were a marionette. The greenskin\'s spirit must have taken offense as the mercenary slips on a discarded shield and goes flying backwards, the dead goblin cartwheeling through the air. The sellsword is hurt, but he\'ll survive.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Be more careful.",
					function getResult()
					{
						this.Contract.m.Dude = null;
						return "Battlesite2";
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();
				local bro = brothers[this.Math.rand(0, brothers.len() - 1)];
				local injury = bro.addInjury(this.Const.Injury.Accident1);
				this.Contract.m.Dude = bro;
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = bro.getName() + " suffers " + injury.getNameOnly()
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "LuckyFind",
			Title = "À the battle site...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{You didn\'t think the men would find much of anything picking through the battlefield, but it appears %randombrother% has managed to find a powerful weapon! | While searching through the remains of the battlefield, %randombrother% manages to uncover an particularly well-made weapon that somehow survived the carnage intact! | A powerful weapon has been found! %randombrother% giddily holds it up for all to see. | %randombrother% starts picking through a pile of weapons. You tell him to cut it out before he cuts himself and loses a limb. He suddenly straightens up, some odd looking battle relic in his hands.%SPEECH_ON%Oh yeah, what do you think now, sir?%SPEECH_OFF%Alright, he wins this one. | You warn the men to keep on the lookout for tracks leading away from the battlefield, but %randombrother% starts rooting through the mounds of corpses looking for something to loot. Just as you\'re about to tell him he\'s gonna hurt himself, the man rears up, a very fine-looking weapon in hand. You give him a thumbs up.%SPEECH_ON%Good job, sellsword!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Not a bad find.",
					function getResult()
					{
						return "Battlesite2";
					}

				}
			],
			function start()
			{
				local item;
				local r = this.Math.rand(1, 10);

				if (r == 1)
				{
					item = this.new("scripts/items/weapons/greatsword");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/weapons/greataxe");
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/weapons/billhook");
				}
				else if (r == 4)
				{
					item = this.new("scripts/items/weapons/noble_sword");
				}
				else if (r == 5)
				{
					item = this.new("scripts/items/weapons/warbrand");
				}
				else if (r == 6)
				{
					item = this.new("scripts/items/weapons/two_handed_hammer");
				}
				else if (r == 7)
				{
					item = this.new("scripts/items/weapons/greenskins/orc_axe_2h");
				}
				else if (r == 8)
				{
					item = this.new("scripts/items/weapons/greenskins/orc_cleaver");
				}
				else if (r == 9)
				{
					item = this.new("scripts/items/weapons/greenskins/named_orc_cleaver");
				}
				else if (r == 10)
				{
					item = this.new("scripts/items/weapons/greenskins/named_orc_axe");
				}

				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Ambush",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_48.png[/img]{As you follow the tracks, a greenskin all of a sudden stands up out from the brush and screams. More rush out into the open all around you. It\'s an ambush! | You follow the tracks, but notice something off. Crouching down, you start sweeping dust and leaves off a track. It\'s pointed the opposite way. Whoever left these marks doubled back which means...\n\n%randombrother% completes your thought, pointing and yelling.%SPEECH_ON%Ambush! Greenskins!%SPEECH_OFF% | You come to a pair of tracks that suddenly branch off in random directions. Following their trails, you realize they disappear into the bushes that surround the path. You sigh and order you men to prepare for battle. No sooner do the words leave your lips does a pack of greenskins start streaming out in ambush! | Things aren\'t what they seem... And just as you think that, a very bug-eyed and sunburned %randombrother% shouts out.%SPEECH_ON%It\'s a trap!%SPEECH_OFF%Greenskins come streaming out of the surrounding bushes. It\'s an ambush! You quickly command your men into formation. | The tracks are easily followed, almost too easily if you\'re honest about it - before the thought can even be finished, a greenskin jumps from some bushes and growls. Across the path, more greenskins do the same. It was a setup! Prepare for battle! | You spot a split in the tracks. Some continue straight ahead while the others branch off and shoot into the bushes along the path. It doesn\'t take a genius to realize what\'s happening: you bark orders to your men to get them into formation. On cue, groups of greenskins come screaming out of the bushes to ambush the %companyname%. Prepare for battle! | The tracks disappear at your feet and you know exactly what that means. Raising your voice, you bark commands to your men to get them into formation. Greenskins start streaming and screaming out of the bushes like banshees. It\'s an ambush! | The tracks continue on ahead, but you notice signs of disturbed earth just beside them. You order the men to halt and crouch down to investigate. As you sweep leaves and dirt aside, you slowly reveal tracks that are actually heading in the opposite direction. The greenskins doubled back... %randombrother% screams out.%SPEECH_ON%Ambush! Ambush!%SPEECH_OFF%You turn to see the savages streaming out of the bushes with weapons raised high and violence in mind. Quickly taking command, you order your men to get into formation. Prepare for battle!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To arms!",
					function getResult()
					{
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "Ambush";
						p.Music = this.Const.Music.GoblinsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						local nearest_goblins = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getNearestSettlement(tile);
						p.EnemyBanners.push(nearest_goblins.getBanner());
						p.Entities = [];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.GoblinRaiders, 125 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "AmbushFailed",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_53.png[/img]{The ambush defeated, you head into the greenskins\' camp to find the prisoners caged and blindfolded. You order the mercenaries to start freeing them. Thinking themselves already dead, most of the prisoners break down in tears and thank you for rescuing them. All in a day\'s work, really. | The greenskins\' ambush failed and so you head into their camp. Any lurking greenskins quickly run off, abandoning everything. You find the prisoners in a tent, huddled together with no clothes. %randombrother% goes and gets some blankets to cover them up for the return trip to %employer%. The freedmen can hardly speak, but their eyes tell a lot about the horrors they\'ve experienced. | The ambush has been dealt with, now you and your men start picking through the greenskins\' abandoned camp. You immediately hear people start screaming from a tent. %randombrother% opens the flap to see a goblin waving a hot iron in front of a group of huddled, naked men. The sellsword cuts the creature\'s head off in a single swipe. The prisoners cry out, thanking you for the rescue. %employer% should be most pleased that at least some of his men will be coming home. | The ambush defeated, you and the %companyname% rush into the greenskins\' encampment. There you find a goblin poking and prodding a man who has ostensibly died from torture. %randombrother% grabs the unwitting goblin and pummels it to death. You search a nearby tent to find a group of blindfolded men huddled in a corner. They skirt away from your voice, but you quickly make it clear that you\'re here to help them. The poor souls have been through a lot. Returning them to %employer% and their homes should make for a good recovery. | Any thought the greenskins\' had about coming out ahead in that fight have been put to rest: those savages are thoroughly dead.\n\nYou order the men to start searching through their encampment to try and find the prisoners. It isn\'t long until %randombrother% finds the men huddled underneath a tent. They\'ve been beaten and tortured, but they\'ll live. A few thank you, and most others thank the old gods. Damn deities stealing your thunder yet again. Anyway, %employer% will be most pleased. | The %companyname% dispatches with the ambush and quickly rushes into the greenskins\' abandoned encampment. You find a man on a spit roasting over a fire. Another is hanging from a tree with his feet cut off. Screaming carries your attention to a nearby tent where you find the rest of the men huddled together and begging for water. Your men start handing out water and tending to their wounds. They\'ll need to be able to walk to get back to %employer% and their homes. | The ambush destroyed, you quickly sweep through the greenskins\' camp. You find a few stragglers, including a goblin trying to make off with a bundle of trophy skulls. %randombrother% makes the savage pay for its gruesome greed with its own head.\n\nIt\'s not long until you find the prisoners huddled together under a sheepskin tent. One cries out.%SPEECH_ON%I knew the old gods would answer our prayers!%SPEECH_OFF%You ask if the old gods will also undo their bindings. The curious, philosophical question goes unanswered when %randombrother% rushes in and frees the prisoners. Ultimately, %employer% will be happy to see them no matter who or whatever is responsible for their rescue. | The greenskins\' laid low, you and the %companyname% sweep through their encampment, slaughtering every straggler you find. The prisoners are freed from a pit in the ground where they had to piss and shit for days, it seems. They kiss the ground and thank you for the rescue. %employer% should be most pleased with this result. | The ambush has been taken care of, but what of the prisoners? You quickly rush into the abandoned greenskin encampment to find the prisoners tied to a series of posts. Unfortunately, the man at the far end has already been tortured to death. Judging by his still leaking wounds, you were just a bit too late. The rest of the prisoners scream out in ecstasy, though. One after the other kisses the earth before your feet. However, now is not the time to feel good about yourself. %employer% will be expecting you with his own thanks: a big pile of crowns.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We have what we came for. Time to Retournez à %townname%!",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "EmptyCamp",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_53.png[/img]{You run into the greenskins\' encampment with weapons raised, but find the whole place abandoned. Pots of stew are turned over and there\'s fresh fires they were quickly left behind. %randombrother% opens a goatskin tent to find the prisoners huddled together. They praise the old gods at the very sight of you. %employer% will be happy with this result, and you\'re happy that the greenskins gave up without a fight. | The greenskins\' camp is abandoned. You find the charred remains of a pig left over as pit and some stews kicked over. They definitely left in a hurry.\n\n%randombrother% calls you over. The prisoners are in a hole in the ground with water up to their waists. A spiked wooden gate is stopping them from getting out, though its tangled with bloodied clothes which suggests at least one man tried. You quickly raise the cover and help them out. You look down to see one body floating in the water. They\'re not all coming back, but %employer% should be more than happy about these few lucky souls. | You rush into the greenskins\' encampment to find the tents all spilt over and a great rush of footsteps leading away from it. They abandoned in it a quick hurry. %randombrother% laughs.%SPEECH_ON%Looks like they knew the %companyname% was coming.%SPEECH_OFF%Suddenly, a voice breaks out of one of the tents, screaming and hollering. You rush over to find a man in hysterics, splayed out on the ground while a bunch of blindfolded men huddle in the corner. The prisoners. Missing fingers, toes, eyes, noses, limbs, the tick tock of time spent in the company of greenskins. You shake your head and order the men to start handing out care. %employer% will be happy about their being alive, but these men are most certainly forever broken. | The greenskins\' camp is empty. A few black birds squawk and fight over some spilt stew while feral dogs scamper at the very sight of you. Your men start searching through the goatskin tents left behind. There\'s nothing to be found until your foot suddenly depresses a little further into the ground than it should. You crouch down and swipe the camouflage away to reveal a trapdoor. Lifting it, you find a well chute the greenskins\' had converted into a very vertical jail cell. The prisoners are squeezed together like tinder and look up at the light with withered, water-worn faces. %randombrother% looks down and grunts.%SPEECH_ON%Well, they\'re alive. I\'ll go get some rope.%SPEECH_OFF% | Footprints trail away from the camp. Judging by the spacing and littering of rubbish, they were in a hurry. %randombrother% calls out to you. He\'s standing outside a tent holding the flap open. When you get there, you see that it was used to house the prisoners. They\'re all naked and on the ground, ears plugged with twigs and eyes blindfolded. Looks like they\'ve been beaten into not moving unless asked. There\'s a pile of human limbs in a corner and it looks like something had taken to using their skulls for primitive artwork. You shake your head.%SPEECH_ON%Free them and give them water. %employer% was probably hoping for the best with getting these men back, but this is just about what I expected.%SPEECH_OFF% | The greenskins\' had abandoned their camp. You\'re not sure why, but most likely their scouts sighted your company and made a business decision to get out while they still could.\n\nThe men are ordered to look for the prisoners and it\'s not long until they\'re found: a goatskin tent with the men huddled beneath a pole with their hands bound and faces literally buried in the dirt. They\'ve been given straws to breathe. %randombrother% hurries over and starts taking their heads out of the ground. Each man\'s face is purpled and gasping for air, but they\'re alive and the torture over. %employer% should be happy to see them coming back. | The encampment is found empty. %randombrother% picks up a spilt cauldron which leaks more sewage than stew. He drops it and shakes his head.%SPEECH_ON%Fire\'s still crackling. They left in a hurry.%SPEECH_OFF%You nod and order the men to fan out and look for the prisoners. No sooner than the words leave your lips do you hear someone screaming from a nearby tent. Inside, you find the prisoners - or those who have survived. On one side of the room the living are naked and huddled. On the other you see a pool of blood, an execution block, a red-stained mallet, and a couple of bodies pinched off at the heads like flowers used for bookmarks. %employer% won\'t be getting all his men back. | Entering the greenskins\' encampment, {you find a goblin shoveling bones into a knapsack. It quickly drops its belongings. %randombrother% runs it down and puts a blade through it. | you find a wounded orc leaning against a pole. He\'s breathing heavy, but with a quick stab of his blade %randombrother% make sure he\'s not breathing at all.} The rest of the camp has been seemingly abandoned, this greenskin the last to remain. You find the prisoners in a tent. They\'ve been blindfolded and a few are missing fingers or toes. %employer% will be most pleased. | The encampment has been abandoned, but the prisoners left behind. You rescue them, or what\'s left of them: some have had their fingers and toes removed, others breathe through holes where their noses used to be. But they\'re alive. That\'s what matters, right? | You come into an encampment which has been abandoned in a hurry. The greenskins most likely saw the %companyname% coming and made a smart decision to leave while they still could. The prisoners are, thankfully, found alive. They thank the old gods and bow before you like paupers before an oracular sage. You get the poor survivors water and prepare a Retournez à %employer%. | A single orc is found at the encampment. It\'s resting against a cage where the prisoners are housed. One of the prisoners has a chain autour de greenskin\'s neck and is pulling it against the bars, warden and prisoner clasped in a most ironic struggle. %randombrother% rushes over and puts a blade through the orc\'s eye and frees the men. The prisoners rush out of the cage kissing the earth and jumping for joy. A giddy man explains that the greenskins left in a hurry and it seems they were mighty scared. You nod and thumb over your shoulder at the sigil of the %companyname%.%SPEECH_ON%They were right to be.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We have what we came for. Time to Retournez à %townname%!",
					function getResult()
					{
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% welcomes you into his room.%SPEECH_ON%I got a good look at the prisoners. What\'s left of them, anyway. They\'re in bad shape, but you did a good job. %reward_completion% crowns, was it?%SPEECH_OFF% | %employer% is pacing his room, occasionally looking out his window. Down below, the prisoners are being taken care of. He shakes his head.%SPEECH_ON%I really did not think a single one of them poor souls would return. You did good, sellsword.%SPEECH_OFF%He slides a satchel of %reward_completion% crowns your way. | You find %employer% personally helping feed the prisoners. He speaks kind words to them. Seeing you, he hands the duties off to a servant and takes you aside.%SPEECH_ON%Look, I know those men are all about useless now. The greenskins didn\'t kill them, but they might as well have. Their bodies press on, but their souls are broken. It\'s no matter. You did what I asked. The guard standing yonder will have %reward_completion% crowns for you. I don\'t know how you do it sellsword. The day-to-day. But I appreciate your services.%SPEECH_OFF% | %employer% stares out his window, his faded shape dimly lit through the thin curtains. Down below, the freed prisoners are being tended to. He shakes his head and comes to his desk.%SPEECH_ON%It\'s sad to see the men like that.%SPEECH_OFF%Taking a satchel of %reward_completion% crowns out and pushing it your way, he continues.%SPEECH_ON%But you brought them home, sellsword, and that\'s what matters most. No man deserves to die in some savage\'s camp.%SPEECH_OFF% | %employer% is found looking at a series of scrolls. A scribe stands at his side, peering down as he rolls a bead between thumb and finger. They both look up at you as you enter the room. You report that the prisoners have been rescued. The nobleman sets a scroll down and then nods to the scribe who promptly pays you %reward_completion% crowns. %employer% claps his hands.%SPEECH_ON%I hope the men made it back alright.%SPEECH_OFF%When you open your mouth to state that some of them did not, the nobleman cuts you off.%SPEECH_ON%I don\'t need a speech, sellsword. I have work to do.%SPEECH_OFF%The scribe smiles warmly as he ushers you out. | The prisoners are taken to a healer who works to mend their horrible wounds. Unfortunately, it is the unseen scars which will truly plague these men for the rest of their lives. %employer% seems happy, though.%SPEECH_ON%It\'s good to have them back. I sure as shite did not think they\'d ever come home. Your talents are one of a kind, sellsword.%SPEECH_OFF%One of a kind, maybe, but no remotely different from other mercenary companies: you ask for your pay. The reminder has the nobleman snapping his fingers. A guard promptly comes over with %reward_completion% crowns. | You escort the rescued men into %townname%. %employer% is standing on a balcony clapping.%SPEECH_ON%Bravo, bravo! Guard!%SPEECH_OFF%An armored man rushes to you with a satchel of %reward_completion% crowns. | The rescued prisoners are taken into the care of a bunch of old healers who, themselves, look as though they had lived lives within a greenskin encampment. Wounded warriors taken care of by their forbearers. %employer% seems most happy, personally handing you a satchel of %reward_completion% crowns.%SPEECH_ON%You know, we nobles had some bets on whether or not those men would come back alive. I bet on you, sellsword. I knew you could do it! I made more money than I just paid you! Isn\'t that hilarious?%SPEECH_OFF% | You and %employer% watch as the rescued prisoners are led into an apothecary\'s shop. The nobleman disappointedly shrugs.%SPEECH_ON%Well, shit.%SPEECH_OFF%That was not the reaction you were expecting. He leans over and explains in a hushed whisper.%SPEECH_ON%We had running bets on whether or not those men would return. I lost a lot of crowns on your good work, sellsword.%SPEECH_OFF%You nod and put a hand out.%SPEECH_ON%Well, it\'s time you lost %reward_completion% crowns more.%SPEECH_OFF% | %employer% greets you at his door with a grin and a satchel of %reward_completion% crowns.%SPEECH_ON%We had an expectation of failure here, sellsword. Me, the other noblemen, the townspeople. Nobody thought those men would ever come back and yet, there they are.%SPEECH_OFF% | %employer% personally sees to it that the rescued prisoners are taken care of, the nobleman doling out water, food, and bandages. It seems done more for publicity than out of earnest. %employer% sees you and comes over, wiping the back of his hand on your sleeve.%SPEECH_ON%Ugh, one of them bled on me. Here\'s your %reward_completion% crowns, sellsword. Didn\'t think you could do it, but here they are. Doubt they\'ll be of much use to me, if I\'m honest, but it\'s the thought that counts.%SPEECH_OFF%Strangely, you feel compelled to tell him to ease up on the honesty. | You help the rescued prisoners through the gates of %townname%. %employer% is waiting at the steps of an apothecary\'s shop with a retinue of guards. They help the men to their care. The nobleman sends a scribe your way with a satchel of %reward_completion% crowns. | You find %employer% in his room. A rather lithe woman is dutifully crushing leaves with a mortar and pestle. Not seeing you, she turns to the nobleman, holding the bowl out.%SPEECH_ON%This should help it rise.%SPEECH_OFF%%employer% sees you over her shoulder and jumps to his feet.%SPEECH_ON%Sellsword! It is good to see you! I take it the prisoners were rescued?%SPEECH_OFF%You report all that occurred. The nobleman ushers the woman forward with a bag of %reward_completion% crowns.%SPEECH_ON%Give this man his reward, my lady.%SPEECH_OFF% | You lead the rescued prisoners through %townname%\'s gates. A crowd of women await them, the wives wrapping their arms autour deir husbands, the widows collapsing to their knees.\n\n%employer% walks over, a lady to each arm. He nods at the scene.%SPEECH_ON%Very sad. Say, what was your reward, %reward_completion% crowns?%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Des couronnes bien méritées.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Freed prisoners from greenskins");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isGreenskinInvasion())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCriticalContract);
						}

						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] Couronnes"
				});
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		if (this.m.BattlesiteTile == null || this.m.BattlesiteTile.IsOccupied)
		{
			local playerTile = this.World.State.getPlayer().getTile();
			this.m.BattlesiteTile = this.getTileToSpawnLocation(playerTile, 6, 12, [
				this.Const.World.TerrainType.Shore,
				this.Const.World.TerrainType.Ocean,
				this.Const.World.TerrainType.Mountains
			], false);
		}

		_vars.push([
			"location",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.m.Destination.getName()
		]);
		_vars.push([
			"dude_name",
			this.m.Dude == null ? "" : this.m.Dude.getNameOnly()
		]);
		_vars.push([
			"hurtbro",
			this.m.Dude == null ? "" : this.m.Dude.getName()
		]);

		if (this.m.Destination == null)
		{
			_vars.push([
				"direction",
				this.m.BattlesiteTile == null ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.BattlesiteTile)]
			]);
		}
		else
		{
			_vars.push([
				"direction",
				this.m.Destination == null || this.m.Destination.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Destination.getTile())]
			]);
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
				this.m.Destination.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isGreenskinInvasion())
		{
			return false;
		}

		return true;
	}

	function onSerialize( _out )
	{
		if (this.m.Destination != null && !this.m.Destination.isNull())
		{
			_out.writeU32(this.m.Destination.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		this.contract.onDeserialize(_in);
	}

});

