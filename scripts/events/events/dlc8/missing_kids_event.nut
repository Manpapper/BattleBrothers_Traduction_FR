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
		this.m.Title = "À %townname%";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_31.png[/img]{Alors que vous déambulez dans les rues de %townname%, une ribambelle de gardes maigrichons surgit soudain d\'une ruelle comme une meute de rats et, comme les rats eux-mêmes, ils sont très nombreux. Alors que vous gardez la tête basse, %anatomist% l\'anatomiste ne peut s\'empêcher de les fixer d\'un regard niais et d\'attirer leur attention. Les gardes établissent un contact visuel et s\'approchent, et comme prévu, ils commencent à cracher leur venin.%SPEECH_ON%Salut voyageurs. La rumeur court en ville que quelqu\'un tue des enfants. L\'anatomiste essaie de se défendre, mais vous savez que la raison et la rationalité ne sont pas vraiment à l\'ordre du jour ici. Vous demandez aux gardes ce qu\'ils veulent. Ils répondent : \"Que diriez-vous d\'un chantage à la couronne?\" et on laisse tomber cette horrible affaire de meurtre de gosse. Dans le cas contraire, on vous casse la gueule à tous les deux.%SPEECH_OFF%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "D\'accord, on va payer pour notre tranquilité.\'",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "On va rien payer du tout.",
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
						Text = "Où est %hedgeknight% le chevalier errant quand on en a besoin?",
						function getResult( _event )
						{
							return "Hedge";
						}

					});
				}

				if (_event.m.Cultist != null)
				{
					this.Options.push({
						Text = "Avez-vous quelque chose à dire, %cultist% le cultiste ?",
						function getResult( _event )
						{
							return "Cultist";
						}

					});
				}

				if (this.Const.DLC.Unhold && _event.m.Killer != null)
				{
					this.Options.push({
						Text = "%killer% le tueur sait comment esquiver des gardes, comment ferait-il?",
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
			Text = "[img]gfx/ui/events/event_31.png[/img]{Vous les payez en or. Ils le prennent et s\'en vont en riant. %anatomiste% explique qu\'il n\'a jamais tué d\'enfant et qu\'il ne le ferait jamais s\'il n\'y avait pas de valeur scientifique à en tirer. Vous fermez les yeux et lui demandez si donc il l\'a déjà fait auparavant. L\'anatomiste se gausse. %SPEECH_ON%Je les écraserais, monsieur.%SPEECH_OFF%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bien sûr que vous le feriez.",
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
			Text = "[img]gfx/ui/events/event_31.png[/img]{Vous leur dites que vous allez devoir compter combien d\'argent vous avez. En regardant vos poches, vous dites : %SPEECH_ON% Je crois que j\'en ai cinq. %SPEECH_OFF% Le plus maigre des gardes s\'avance en disant : "cinq quoi ?" Et vous répondez par un coup en plein visage. Avant même que l\'homme ne touche le sol, le reste des gardes fondent sur vous deux, vous donnant des coups de pied et des coups de poing en vous piétinant. Ils fouillent vos poches mais sans rien trouver. Ils finissent par lâcher prise et reculent, une foule de paysans se rassemblant lentement autour de la scène. Un garde gifle l\'autre, indiquant qu\'il est temps de partir. Le garde principal vous regarde fixement.%SPEECH_ON%Connard, tu sais vraiment encaisser. J\'espère que cette raclée en va te servir de leçon. Allez, sortons d\'ici. %SPEECH_OFF%Lentement, vous vous relevez et aidez %anatomist% à faire de même. Il essuie le sang de son visage. Vous êtes habitué à une raclée, mais vous vous dites que c\'est peut-être une première pour l\'anatomiste. il continue d\'essuyer le sang qui coule de son nez. Vous lui dites de pencher la tête en arrière et vous le ramenez vers le chariot. L\'anatomiste parle avec une voix chevrotante.%SPEECH_ON%Mon nez continue de saigner. Je sais que c\'est ce pour quoi il a été conçu, mais le voir et le sentir en personne... fascinant. Très fascinant.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ça vieillit vite, crois-moi.",
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
			Text = "[img]gfx/ui/events/event_96.png[/img]{%hedgeknight% le chevalier errant tourne soudainement au coin de la rue. Les gardes font un pas en arrière. Il mange une pomme d\'une main tandis que l\'autre est posée sur le pommeau de son arme comme la main d\'un bourreau sur son levier. Il regarde les gardes un à un, les jugeant et les trouvant mauvais. Il prend une autre bouchée de sa pomme et se tourne vers vous. %SPEECH_ON% Y a-t-il un problème ici, capitaine? %SPEECH_OFF%Un des gardes s\'avance rapidement, souriant anxieusement. %SPEECH_ON%Ah, pas de problème. Nous faisons juste notre boulot%SPEECH_OFF%Le chevalier errant jette le trognon par-dessus son épaule et s\'étire longuement, les pièces de son armure grinçant et s\'entrechoquant. Il hoche la tête. %SPEECH_ON%Et comment ça se passe? %SPEECH_OFF%Les gardes annoncent qu\'ils viennent de terminer. Le chevalier errant sourit et dit que le temps, c\'est de l\'argent. Déglutissant nerveusement, l\'un des gardes vous donne une bourse de pièces. Il s\'excuse de vous avoir fait perdre votre temps. Le groupe de gardes maigrichons bat alors en retraite, jusqu\'à ce qu\'ils disparaissent. %hedgeknight% soupire. Il dit qu\'il attendait que vous lui donniez le signal. Vous lui demandez quel type de signal il aurait du s\'agir. Il sort une autre pomme et l\'écrase d\'une pression féroce de sa main. Il porte un des morceaux à sa bouche.%SPEECH_ON% Qu\'est-ce que vous en pensez?%SPEECH_OFF%.}",
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
			Text = "[img]gfx/ui/events/event_03.png[/img]{Avant que vous puissiez répondre, un petit sac s\'envole et lorsqu\'il atterrit, un tas d\'os de poulet en sort. Des bruits de pas suivent, tout le monde se retourne pour voir qui les fait. %cultist% le cultist s\'avance, se penche et ramasse un des os. Il se tourne vers les gardes et dit qu\'aucun enfant n\'a disparu ici, que leurs rapports sont des mensonges. L\'un des gardes maigrichon baisse la tête. %SPEECH_ON%Et qui diable êtes-vous?%SPEECH_OFF%Le cultistes s\'avance vers les gardes, les os craquant sous ses bottes. Il se penche à l\'oreille de l\'un d\'eux et commence à chuchoter. Quand le cultistes a fini, le garde se penche en arrière.%SPEECH_ON% Je teste sa patience?%SPEECH_OFF%Le cultistes acquiesce et dit. %SPEECH_ON%Oui, tester sa patience est une énorme erreur. Arretez-vous avant de faire quelque chose que vous pourrez regretter amèrement.%SPEECH_OFF%Les gardes se regardent. L\'un d\'eux offre des couronnes comme si c\'était une pénitence. Vous prenez volontiers les couronnes et, étrangement, elles sont chaudes au toucher. %cultist% se retourne et hoche la tête, murmurant quelque chose à propos de la détermination d\'êtres qui dépassent de loin votre compréhension.  Vous regardez les os, mais vous ne vous souvenez pas que la compagnie ait reçu des poulets, et vous ne vous souvenez pas non plus qu\'il y ait eu des poulaillers sur votre chemin.%SPEECH_ON% Ceux-ci ressemblent à-%SPEECH_OFF% L\'anatomiste parle un peu trop fort de ce à quoi ils ressemblent et vous l\'interrompez sur le champ, préférant prendre la poudre d\'escampette avant que cette étrange situation ne tourne au vinaigre.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Allons-nous-en d\'ici.",
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
			Text = "[img]gfx/ui/events/event_20.png[/img]{Vous ouvrez la bouche pour répondre quand soudain une femme crie. Les deux parties se retournent pour voir un homme à moitié nu se tordant au bout d\'une corde, le cou tourné dans un angle des plus incompatibles avec la vie. Cependant, ce n\'est pas la chute qui l\'a tué, son corps a été mutilé, taillé avec toutes sortes d\'instruments de torture. Il y a une silhouette au sommet d\'un balcon qui regarde en bas, une paire d\'yeux sauvages et un sourire en coin démentant toute notion de conscience coupable. Les gardes crient et se mettent en chasse. En riant, la silhouette disparaît du balcon. Vous entendez les gardes courir après le meurtrier dans tout %townname%. Bientôt, vous n\'entendez plus que les éclaboussures de sang qui s\'écoulent du cadavre et le clapotis des chiens de la ruelle qui sont venus le lécher. %anatomiste% le regarde attentivement. Il ouvre la bouche, mais %killer% apparaît soudainement.%SPEECH_ON%Bonjour Capitaine. J\'ai pensé que vous aimeriez les voir.%SPEECH_OFF% Il vous remet des pièces d\'armure dont les métaux sont couverts de sang. Pas besoin d\'être un génie pour savoir d\'où viennent ces objets, mais ils sont tout de même très beaux et méritent d\'être gardés. Vous lui dites de les nettoyer et de les porter au stock. L\'homme acquiesce. Il prend une longue et grande inspiration et laisse tout sortir avec un large sourire.%SPEECH_ON%Je suis sûr que vous allez aimer les grandes villes.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Eh bien, au moins quelqu\'un en vit.",
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
		local anatomist_candidates = [];
		local cultist_candidates = [];
		local hedge_candidates = [];
		local killer_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist" && !bro.getSkills().hasSkill("injury.broken_nose"))
			{
				anatomist_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
			{
				cultist_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.hedge_knight")
			{
				hedge_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.killer_on_the_run")
			{
				this.killerCandidates.push(bro);
			}
		}

		if (cultist_candidates.len() > 0)
		{
			this.m.Cultist = cultist_candidates[this.Math.rand(0, cultist_candidates.len() - 1)];
		}

		if (hedge_candidates.len() > 0)
		{
			this.m.Hedge = hedge_candidates[this.Math.rand(0, hedge_candidates.len() - 1)];
		}

		if (killer_candidates.len() > 0)
		{
			this.m.Killer = killer_candidates[this.Math.rand(0, killer_candidates.len() - 1)];
		}

		if (anatomist_candidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomist_candidates[this.Math.rand(0, anatomist_candidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = 8 + anatomist_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getNameOnly()
		]);
		_vars.push([
			"blackmail",
			750
		]);
		_vars.push([
			"cultist",
			this.m.Cultist != null ? this.m.Cultist.getNameOnly() : ""
		]);
		_vars.push([
			"hedgeknight",
			this.m.Hedge != null ? this.m.Hedge.getNameOnly() : ""
		]);
		_vars.push([
			"killer",
			this.m.Killer != null ? this.m.Killer.getNameOnly() : ""
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

