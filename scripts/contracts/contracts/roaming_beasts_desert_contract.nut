this.roaming_beasts_desert_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		IsPlayerAttacking = true
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.roaming_beasts_desert";
		this.m.Name = "Hunting Beasts";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 500 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
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
					"Chassez ce qui terrorise " + this.Contract.m.Home.getName()
				];
				this.Contract.setScreen("Task");
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 40)
				{
					this.Flags.set("IsHyenas", true);
				}
				else if (r <= 80)
				{
					this.Flags.set("IsSerpents", true);
				}
				else
				{
					this.Flags.set("IsGhouls", true);
				}

				local playerTile = this.World.State.getPlayer().getTile();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 5, 10);
				local party;

				if (this.Flags.get("IsHyenas"))
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Hyenas", false, this.Const.World.Spawn.Hyenas, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					party.setDescription("A pack of esurient hyenas on the hunt for prey.");
					party.setFootprintType(this.Const.World.FootprintsType.Hyenas);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Hyenas, 0.75);
				}
				else if (this.Flags.get("IsGhouls"))
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Nachzehrers", false, this.Const.World.Spawn.Ghouls, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					party.setDescription("A flock of scavenging nachzehrers.");
					party.setFootprintType(this.Const.World.FootprintsType.Ghouls);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Ghouls, 0.75);
				}
				else
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Serpents", false, this.Const.World.Spawn.Serpents, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					party.setDescription("Giant serpents slithering about.");
					party.setFootprintType(this.Const.World.FootprintsType.Serpents);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Serpents, 0.75);
				}

				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);
				this.Contract.m.Target = this.WeakTableRef(party);
				party.getSprite("banner").setBrush("banner_beasts_01");
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setPivot(this.Contract.m.Home);
				roam.setMinRange(2);
				roam.setMaxRange(8);
				roam.setAllTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
				roam.setTerrain(this.Const.World.TerrainType.Shore, false);
				roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
				c.addOrder(roam);
				this.Contract.m.Home.setLastSpawnTimeToNow();
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || !this.Contract.m.Target.isAlive())
				{
					if (this.Flags.get("IsHyenas"))
					{
						this.Contract.setScreen("CollectingHyenas");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsGhouls"))
					{
						this.Contract.setScreen("CollectingGhouls");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsSerpents"))
					{
						this.Contract.setScreen("CollectingSerpents");
						this.World.Contracts.showActiveContract();
					}

					this.Contract.setState("Return");
				}
				else if (!this.Flags.get("IsWorkOfBeastsShown") && this.World.getTime().IsDaytime && this.Contract.m.Target.isHiddenToPlayer() && this.Math.rand(1, 9000) <= 1)
				{
					this.Flags.set("IsWorkOfBeastsShown", true);
					this.Contract.setScreen("WorkOfBeasts");
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Retournez à " + this.Contract.m.Home.getName()
				];
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					if (this.Flags.get("IsHyenas"))
					{
						this.Contract.setScreen("Success1");
					}
					else if (this.Flags.get("IsGhouls"))
					{
						this.Contract.setScreen("Success2");
					}
					else if (this.Flags.get("IsSerpents"))
					{
						this.Contract.setScreen("Success3");
					}

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
			Title = "Negotiations",
			Text = "[img]gfx/ui/events/event_162.png[/img]{You enter %employer%\'s place to find him standing over a fancy rug littered with human body parts. He looks up at you.%SPEECH_ON%These were beast slayers, allegedly, and now here they are, recovered from the task at which they were directed.%SPEECH_OFF%The Vizier nods and a few helpers come over and roll up the rug. Flesh and guts flop and squeeze together and gush out the sides. The servants tilt the rug up, throw it onto their shoulders and march it out, with one dismembered hand flopping lazily from one end. %employer% claps his hands.%SPEECH_ON%In the desert lives my problem, a collection of cruel beasts that are harvesting the locals. I\'ve stared into the Eternal Fires and found guidance to seek a Crownling to help resolve this monstrous issue. Do you, Crownling, find %reward% crowns a suitable allotment to purchase your temporary allegiance?%SPEECH_OFF% | You walk into %employer%\'s domicile, but a veritable wall of guards stop you from approaching any closer. He stands at the base of a throne with a short staircase descending from it. He walks down it with deliberation at every step, coming to the landing. A man looks back at him, and the Vizier nods. The man looks back at you and hands you a scroll. It reads that creatures of an undetermined sort are wreaking havoc within the protectorate of %townname%. If you find and destroy said monsters you are to be rewarded in a manner suitable to the task, %reward% crowns. | %employer% is found surrounded by a harem of half-naked women. He is holding up a severed hand which, surprisingly, the women seem more fascinated with than disgusted. As he sees you, the Vizier drops the hand and wipes his hand on the shoulder of one of the women, this time garnering a fair bit of disdain, albeit slavenly muted.\n\n%employer% snaps his fingers at a servant who rushes over with a jar of wine. The Vizier sighs and shoos the servant away and snaps his fingers once more. A second servant realizes he\'s been called and comes forward, hurriedly handing you a scroll and speaks its words aloud: monsters have been spotted near %townname% and they are to be destroyed posthaste.\n\n The reward for this is not spoken quite so loudly. Instead, the servant taps the page where a number has been written: %reward% crowns. | %employer% is standing over a map so enormous that it cannot fit on any table, but is instead parceled out and spread across the marbled floor. It seems unnecessary, as a map could be easily contained in proper resolution, but you keep this observation to yourself. The Vizier walks over the paper and points at a location.%SPEECH_ON%Beasts have set upon this part of the realm and are seeing to its destruction in a manner that I have not agreed to. I\'ve more important matters to attend to there.%SPEECH_OFF%He points to another area of the map which just looks like a bunch of empty desert. He continues.%SPEECH_ON%So I need a man such as yourself, Crownling, to see these roaming monsters. Particular to your success, you will be rewarded %reward% crowns which should be more than suitable.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Let\'s talk more about payment. | This is our kind of work.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{This doesn\'t sound like our kind of work. | I wish you luck, but we\'ll not be part of this.}",
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
			ID = "WorkOfBeasts",
			Title = "Along the way...",
			Text = "[img]gfx/ui/events/event_161.png[/img]{Blood in the desert, thick enough to set top the sands. You follow the speckled marks to a large sand dune and crest it. On the other side is a series of limbs scattered down the slope. A torso. One body missing a face. Deep divots in the sands lead away from the area. You\'re not on time to save these people, but you are close. | You come to a well with a hut beside it. The door is open and slanted off a broken hinge. With a sword drawn, you slowly push it open and find a pile of mush that may have once been a man. Blood drips from the ceiling and there\'s a hole in the opposite side of the hut where whatever damaged all this made its leave as violent as its entrance. The beasts must be close. | Bodies litter the area around a desert well. As you draw near, a pair of hands slap to the edges of the wellhead and pull the person up. It is an old man. He clears his legs over the wall and sits there, gathering his breath. He points autour de scene and shrugs. It seems the beasts were just here, but you have just missed them. You go to your canteen and offer it to the old man, but he shoos you away. There is great pain being held in his eyes, but he fights hard to make sure you see little of it.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We move on.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CollectingHyenas",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_159.png[/img]{You\'re not entirely sure, as you\'re not particularly knowledgeable about the creature, but you find yourself staring at the hyenas with contempt. They bear the marks of trash diggers, cretins which hunt the weak despite having the strength and numbers to fight for their food. It is only when meeting you, seeing their own finality on the line, did they decide to fulfill their beastly destiny. You cut their heads off and ready a Retournez à %employer%. | The hyenas are contemptuous creatures, but they are tough. Even in death you find yourself having to hack and chop at the necks just to gain some purchase there, and sawing the heads free requires even more time. But soon the deed is done and you ready to take the pates and pelts back to %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Let\'s be done with this, we have crowns to collect.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CollectingGhouls",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_131.png[/img]{The fight over, you walk to a dead ghoul and take a knee. Were it not for a gate of ill-shapen teeth, you could easily fit your head into the beast\'s oversized maw. Instead of admiring the dental failures at hand, you take out a knife and saw its head off. You raise the token up and order the %companyname% to follow suit. %employer% will be expecting more proof than just one head, after all. | The ghoul\'s dead body looks more rock than beast as it lays flat and unmoving. Flies are already coupling inside its mouth, sowing life on the frothy remains of death. You order %randombrother% to take its head, for %employer% will be expecting proof. | Dead ghouls are scattered about. You take a knee beside one and look at its mouth. A long broth breath of a blech gurgles from its lungs. Putting a cloth to your nose, you use a dagger to cut the head off. You order a few brothers to follow suit for %employer% will be expecting proof. | A dead ghoul is an interesting specimen to behold. You can\'t help but wonder where it falls on the natural spectrum. Shaped like some hermitic wildman, toned muscles in the manner of a predator, and its head seems more stone than flesh. Curiosity put aside, you order the %companyname% to start collecting scalps for %employer% will surely be wanting proof.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Back to %townname%!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CollectingSerpents",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_169.png[/img]{You crouch before one of the sand serpents. From one end to the other, you could lay flat a few times over and still not reach its full length. A fascinating snake to be sure. You start skinning them to return the wares to %employer% as proof. | The serpents are cut to pieces and you haul together the good bits - mostly their flatheads and curious tails - so as to offer proof to %employer% of a deed completed.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Back to %townname%!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "On your return...",
			Text = "[img]gfx/ui/events/event_162.png[/img]{%employer% is already outside his palace when you return. He has a few men in silken garb standing at his side. When you deposit the hyenas\' corpses, these men hurry the bodies away. The Vizier remains with a few guards at his sides. He snaps his fingers and a servant hands you a chest of crowns. The Vizier nods.%SPEECH_ON%Well done, Crownling. We shall make good use of these parcels which you have delivered in good time.%SPEECH_OFF%Parcels? You thought you were here to help solve a monster menace. As guards hurry you out of the square, you eye one of the wise men using a protractor to start making measurements while another man sets up a pedestal and begins to paint. | %employer% stands at his door, though you are kept at a good distance. His servants, instead, are the ones to greet you. They take the hyena scalps and loft them into silvered wheelbarrows. The servants scamper the goods back across the yard and disappear just as soon as they came. The Vizier whistles like a hawk bearing down on its prey. You twitch for a second, but all that comes is another pair of servants carrying a trove of crowns. One looks to the sky as he recites.%SPEECH_ON%Crownling, this job, you have done well, see to the chest, and you will find your purse swell.%SPEECH_OFF%The servant clicks his tongue and looks down, grinning wildly.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "A successful hunt.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Rid the area of hyenas");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] Crowns"
				});
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "On your return...",
			Text = "[img]gfx/ui/events/event_162.png[/img]{%employer% is welcomes you into his throne room. It is filled to the brim with what look like very important people, yet you are brought in anyway. Pausing briefly because you\'re not sure if the crowd can take it, you shrug and then spill out the nachzehrers\' remains. The froth of blood and guts and heads puddles across the floor, but not a peep comes from the onlookers.\n\nAll you can hear is the soft steps of the Vizier walking over. He stares at the remains, hands clasped before him like some scientist, then he snaps his fingers and a horde of servants come over and clean up the mess. One man with a quill pen and papers makes notations. When all is said and done the Vizier returns to this throne and sits in silence. The only other sound you hear is the chinky-chank of a treasure chest being dragged over. All %reward% crowns are handed to you as promised, then you are quietly urged to leave the room.\n\n Looking back, you see the crowd return their attention to the Vizier who starts into prayers. | A man stops you outside %employer%\'s room. He has with him a few scrawny men with quill pens and ledgers. They descend upon your collection of nachzehrers and make attributions accordingly to their papers. Each one finishes and tears the page away and hands it to the first man who compares his notes. Satisfied, he hands you a purse of %reward% crowns.%SPEECH_ON%May your road be ever gilded, Crownling.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "A successful hunt.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Rid the area of nachzehrers");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] Crowns"
				});
			}

		});
		this.m.Screens.push({
			ID = "Success3",
			Title = "On your return...",
			Text = "[img]gfx/ui/events/event_162.png[/img]{You meet with employer in his garden. He stares at you with a pair of clipping scissors in hand.%SPEECH_ON%I take it the task is completed?%SPEECH_OFF%Nodding, you produce a serpent\'s head and throw it to the ground. It plops mutely and rolls to the Vizier\'s foot which slowly moves out of the way. %employer% looks at you sternly.%SPEECH_ON%Theatrics are not necessary, Crownling, it is the completion of the task itself which is suitable in impressing me. My guards will furnish your purse a weight of %reward% crowns, as agreed upon.%SPEECH_OFF% | You drag the serpent skins toward %employer%, but a man wearing a feathered turban stops you. He speaks in what sounds like gibberish, though the occasional word slips through. It seems he is in the employ of the Vizier, and he is taking the serpent\'s remains. You look to %employer% who nods to confirm that this is what is to happen. He also seems to notice the signs of tension on your face as you worry about your payment. He speaks loudly and proudly.%SPEECH_ON%Fear not, Crownling, the only snakes here are the ones you have brought to us.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "A successful hunt.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Rid the area of serpents");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] Crowns"
				});
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_helpful = [];
		local candidates_bro1 = [];
		local candidates_bro2 = [];
		local helpful;
		local bro1;
		local bro2;

		foreach( bro in brothers )
		{
			if (bro.getBackground().isLowborn() && !bro.getBackground().isOffendedByViolence() && !bro.getSkills().hasSkill("trait.bright") && bro.getBackground().getID() != "background.hunter")
			{
				candidates_helpful.push(bro);
			}

			if (!bro.getSkills().hasSkill("trait.player"))
			{
				candidates_bro1.push(bro);

				if (!bro.getBackground().isOffendedByViolence() && bro.getBackground().isCombatBackground())
				{
					candidates_bro2.push(bro);
				}
			}
		}

		if (candidates_helpful.len() != 0)
		{
			helpful = candidates_helpful[this.Math.rand(0, candidates_helpful.len() - 1)];
		}
		else
		{
			helpful = brothers[this.Math.rand(0, brothers.len() - 1)];
		}

		if (candidates_bro1.len() != 0)
		{
			bro1 = candidates_bro1[this.Math.rand(0, candidates_bro1.len() - 1)];
		}
		else
		{
			bro1 = brothers[this.Math.rand(0, brothers.len() - 1)];
		}

		if (candidates_bro2.len() > 1)
		{
			do
			{
				bro2 = candidates_bro2[this.Math.rand(0, candidates_bro2.len() - 1)];
			}
			while (bro2.getID() == bro1.getID());
		}
		else if (brothers.len() > 1)
		{
			do
			{
				bro2 = brothers[this.Math.rand(0, brothers.len() - 1)];
			}
			while (bro2.getID() == bro1.getID());
		}
		else
		{
			bro2 = bro1;
		}

		_vars.push([
			"helpfulbrother",
			helpful.getName()
		]);
		_vars.push([
			"bro1",
			bro1.getName()
		]);
		_vars.push([
			"bro2",
			bro2.getName()
		]);
		_vars.push([
			"direction",
			this.m.Target == null || this.m.Target.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Target.getTile())]
		]);
	}

	function onHomeSet()
	{
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Target != null && !this.m.Target.isNull())
			{
				this.m.Target.getSprite("selection").Visible = false;
				this.m.Target.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		return true;
	}

	function onSerialize( _out )
	{
		if (this.m.Target != null && !this.m.Target.isNull())
		{
			_out.writeU32(this.m.Target.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}

		this.contract.onDeserialize(_in);
	}

});

