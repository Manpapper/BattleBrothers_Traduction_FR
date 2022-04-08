this.undead_hoggart_event <- this.inherit("scripts/events/event", {
	m = {
		Witchhunter = null,
		Other = null
	},
	function create()
	{
		this.m.ID = "event.crisis.undead_hoggart";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_76.png[/img]Marchant sous une pluie brumeuse et chaude, vous apercevez une silhouette debout au milieu du chemin. Il tient une torche à couronne de métal, sans doute le feu d\'un homme qui veut être vu. Alors que vous vous approchez, il pose la torche, éclairant un visage étrangement familier, même si vous n\'arrivez pas à mettre le doigt dessus. Vous lui ordonnez de s\'annoncer.%SPEECH_ON%Êtes-vous beaucoup de mercenaires, hm ?%SPEECH_OFF%Vous lui dites que ce n\'est pas un nom. Il s\'éclaircit la gorge, une douce lueur orange sur son visage scrutant l\'obscurité de la tempête.%SPEECH_ON%Mon nom est Barnabas. Louez-vous votre épée ou non ?%SPEECH_OFF%Prudemment, vous traversez le chemin et vous vous approchez de l\'homme. Il écarte la torche.%SPEECH_ON%Ouais, j\'en ai pensé autant. Mon frère, j\'ai besoin de quelqu\'un... Je veux dire, je ne peux pas...%SPEECH_OFF%Vous hochez la tête et parlez pour lui.%SPEECH_ON%Il est sorti de la tombe et maintenant vous voulez que quelqu\'un prenne prends soin de lui.%SPEECH_OFF%L\'homme hoche la tête, il agite la torche vers un endroit là-bas où une faible lumière brûle au loin.%SPEECH_ON%Il est parti. Je vous paierai %reward% couronnes, vu que c\'est votre boulot.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "D\'accord, montrez le chemin.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Ce n\'est pas notre problème.",
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
			Text = "[img]gfx/ui/events/event_76.png[/img]Vous dites à l\'homme de montrer le chemin, en amenant %chosenbrother% avec vous et en laissant un autre mercenaire en charge pendant votre absence. Barnabas vous conduit sur une colline et jusqu\'à la clôture d\'une propriété abritant une maison en pierre de taille décente. La lumière des bougies scintille au-delà des fenêtres. Barnabas regarde vers l\'avant.%SPEECH_ON%Personne n\'est là. Le seul ici est Hoggart.%SPEECH_OFF%Ce nom... Le visage de Barnabas... Vous attrapez l\'homme et le poussez contre la clôture, exigeant de savoir s\'il est le frère du bandit. Barnabas acquiesce rapidement.%SPEECH_ON%Oui, c\'est moi ! Qu\'en est-il ?%SPEECH_OFF%Vous lui dites que Hoggart a presque anéanti la %companyname% et qu\'en retour, vous avez tué l\'homme. Barnabas lève les mains.%SPEECH_ON%Si c\'est le cas, c\'est comme ça. Hoggart ne faisait que ce dont il avait besoin pour garder la propriété dans la famille. Après la mort de notre père, nous avons contracté des dettes - des dettes que nous ne pouvions pas payer.%SPEECH_OFF%Vous tirez un poignard et le placez sous la gorge de l\'homme. Il secoue la tête.%SPEECH_ON%Je ne suis pas ici pour te tendre une embuscade ou te voler. La maison a été vendue. C\'est hors de la famille. Mais Hoggart... il est revenu et il ne partira pas.%SPEECH_OFF%Vous regardez par-dessus l\'épaule de Barnabas. Il y a une silhouette sombre devant la maison, éclairée par la lumière de la fenêtre.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ok. Nous allons jeter un coup d\'oeil.",
					function getResult( _event )
					{
						return "E";
					}

				},
				{
					Text = "Je vais terminer ça juste ici.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Ce n\'est plus notre problème.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_76.png[/img]Les lignées ne sont pas facilement brisées. Quoi que Barnabas dise, il est probable qu\'il viendra après la compagnie un jour, un jour quand il fera froid et calme et que les feux de la vengeance ne pourront pas être éteints si facilement.\n\n Vous lui demandez de montrer la voie, et à la seconde où il se retourne, vous le poignardez juste sous l\'aisselle, lui transperçant le cœur. Il ne dit rien. Il se met simplement à genoux, face au dos de son frère et à la maison dans laquelle il a grandi. Il est assis là, prostré et mourant, la pluie crépitant contre la torche jusqu\'à ce qu\'elle grésille. %chosenbrother% crache.%SPEECH_ON%Bien joué, monsieur.%SPEECH_OFF%Il fouille le corps et trouve un poignard brillant. Peut-être l\'outil d\'un assassin, peut-être le dernier héritage d\'un nom de famille décédé. Dans tous les cas, vous le prenez et retournez au %companyname%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est ça.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-1);
				local item = this.new("scripts/items/weapons/named/named_dagger");
				item.m.Name = "Barnabas\' Dagger";
				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous obtenez " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_76.png[/img]Ce n\'est pas votre problème, et cela ne devrait jamais l\'être. Hoggart est mort et c\'est tout ce que vous devez ou voulez savoir sur lui ou sur l\'un de ses noms de famille. Vous laissez Barnabas là-bas sous la pluie et retournez au %companyname% pour planifier le prochain voyage.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous avons assez de problèmes de morts-vivants à nous occuper.",
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
			ID = "E",
			Text = "[img]gfx/ui/events/event_76.png[/img]Contre un meilleur jugement, vous allez voir si c\'est vraiment Hoggart. Marchant vers lui, il grogne et regarde par-dessus son épaule. C\'est bien Hoggart, mais il ne fait guère plus que grogner avant de se retourner pour regarder à nouveau la maison. Sortant votre épée, vous vous approchez prudemment. De plus près, vous pouvez voir que la tête de l\'homme a été recousue sur le corps de quelqu\'un d\'autre, peut-être un chevalier basé sur l\'écusson qu\'il porte.\n\n Mais assez de reflexion. Vous balancez votre épée en arrière et l\'abattez sur Hoggart pour un dernier coup - mais une faible main bleue se lance, arrêtant la lame comme si vous aviez frappé une dalle de pierre. Lentement, un visage spectral se tourne, indépendant de Hoggart, et vous regarde. Il hurle avant de disparaître dans le corps prêté du mort.\n\n Barnabas se tient à côté de vous.%SPEECH_ON%Si j\'avais pu le faire aussi facilement, je l\'aurais fait moi-même.%SPEECH_OFF%Il apparaît ici\' une force puissante et malveillante en jeu. Vous devrez trouver une autre solution.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous devons brûler la maison.",
					function getResult( _event )
					{
						return "F";
					}

				},
				{
					Text = "%chosenbrother%, distrait le spectre !",
					function getResult( _event )
					{
						return "G";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Witchhunter != null)
				{
					this.Options.push({
						Text = "Prenons %witchhunter%. Les esprits vils sont son point fort.",
						function getResult( _event )
						{
							return "H";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_76.png[/img]Hoggart tend la main vers sa maison, la saisissant à distance. Ses grognements se transforment en doux gémissements. Une langue défigurée et desséchée déroule quelques mots.%SPEECH_ON%La nôtre... la nôtre... toujours...%SPEECH_OFF%Vous jetez un coup d\'œil à la maison, puis à %chosenbrother%. Il hoche la tête. La maison doit être détruite. Vous allez embraser l\'endroit de l\'intérieur, lancer des torches à travers ses fenêtres et incendier son toit de chaume. Même sous la pluie, il s\'enflamme. Hoggart grogne et son corps se précipite en avant, les bras tendus, les mains tendues jusqu\'au bout des doigts. Le spectre surgit de ses épaules, ses bras translucides attrapant Hoggart par la tête et essayant de le retenir. Le mort grogne et essaie de courir en avant, la tête déchirée par les coutures de ses points de suture. Il crie.%SPEECH_ON%OURS ! J\'AI ESSAYÉ. ALORS. DUR !%SPEECH_OFF%Les points de suture se libèrent et son corps culbute en arrière, sa tête déchirée et tombant dans la boue. Le spectre bleu, arraché du cou, hurle et s\'élève dans le ciel nocturne, un simple scintillement contre la pluie jusqu\'à ce qu\'il disparaisse.\n\n Barnabas va s\'asseoir à côté de Hoggart, les yeux du mort regardant fixement l\'enfer dévorant leur maison d\'enfance. %chosenbrother% récupère l\'armure du corps sur lequel reposait la tête de Hoggart. Vous essayez de parler à Barnabas, mais il refuse de parler. Compréhensif, vous ne le poussez pas et laissez l\'endroit derrière vous, les feux toujours infaillibles contre la pluie lorsque vous partez.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je suppose que c\'est fini.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/armor/named/black_leather_armor");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous obtenez " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_76.png[/img]Vous chuchotez à %chosenbrother% d\'attaquer Hoggart, mais seulement pour essayer de distraire le spectre qui habite son corps. Le mercenaire acquiesce et se met immédiatement au travail, dégainant son arme et chargeant vers l\'avant. Comme on pouvait s\'y attendre, un bras bleu jaillit, croisant sa forme infaillible mais translucide avec l\'arme de %chosenbrother%. Il regarde par-dessus son épaule et crie.%SPEECH_ON%Maintenant !%SPEECH_OFF%Vous sautez en avant et balancez votre épée. Le spectre tourbillonne en hurlant, mais il est trop tard. Votre lame traverse le cou de Hoggart, libérant sa tête d\'un coup rapide, son crâne roulant dans la boue tandis que le corps s\'agite en arrière. Introduit dans le monde tout seul, le spectre hurle et tourbillonne dans le ciel, ne trouvant rien d\'autre que le chaos dans sa liberté retrouvée. %chosenbrother% regarde l\'armure qui était sur le corps de Hoggart et secoue la tête. Ce putain de truc s\'est cassé.\n\n Un groupe d\'hommes traverse soudainement la cour, brandissant des torches et des épées. Un type particulièrement opulent les dirige.%SPEECH_ON%C\'est toi Barnabas ? Je pensais t\'avoir dit de ne plus jamais remettre les pieds sur ma propriété !%SPEECH_OFF%Tu leur expliques ce qui s\'est passé. L\'homme, ostensiblement l\'acheteur du terrain, acquiesce, disant qu\'il a amené avec lui un ecclésiastique pour résoudre le problème, mais maintenant que vous l\'avez fait, il vous verse une jolie somme de couronnes. Lorsque vous vous retournez, les têtes de Barnabas et de Hoggart ont disparu.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'était un contrat rapide.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(300);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous obtenez [color=" + this.Const.UI.Color.PositiveEventValue + "]300[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_76.png[/img]%chosenbrother% dit que %witchhunter% sait probablement quoi faire. Vous acceptez et courez chercher le chasseur de sorcières. A votre retour, il évalue la situation avant de consulter un gros livre caché dans une poche. Il hoche la tête, murmurant pour lui-même pendant qu\'il lit. Enfin, il claque des doigts.%SPEECH_ON%C\'est un Gespenst von Zwei, une hantise de deux âmes. Dans ce cas, celui de Hoggart et celui de l\'homme sur lequel repose maintenant sa tête. Une âme chassée de manière flagrante est assez simple, mais deux combinées constituent une force malveillante et colérique. Si nous détruisons simplement le corps ou la tête, les âmes seront liées ensemble et hanteront les terres pour toujours. Certains font même des gaffes dans le ciel. Malheureusement, au lieu de trouver les cieux, ils trouvent un enfer de confusion sans fin et la fureur qui en découle. Je crois que l\'âme de Hoggart, ou tout ce qui le lie à ce monde, est plus forte que celle de l\'autre homme. La lutte qu\'il a eue dans la vie était trop grande pour se terminer simplement sur son dernier souffle et c\'est pourquoi il se tient devant son ancienne maison.%SPEECH_OFF%Vous arrêtez le chasseur de sorcières et posez la question la plus pertinente...",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Comment pouvons-nous l\'arrêter?",
					function getResult( _event )
					{
						return "I";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Witchhunter.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "I",
			Text = "[img]gfx/ui/events/event_76.png[/img]%witchhunter% force un sourire.%SPEECH_ON%Pardonnez-lui.%SPEECH_OFF%Vous n\'êtes pas sûr de l\'avoir bien entendu, vous faites écho à sa phrase et le chasseur de sorcières hoche la tête.%SPEECH_ON%Oui, excusez-vous. Et le dire aussi. Beaucoup d\'hommes sont tellement remplis de haine, ou tellement remplis de désir, que tout échec se contextualise comme une énergie au-delà de la dépouille mortelle. Vous avez tué cet homme. C\'est vous qui avez bouleversé une vie qui ne pouvait tolérer la moindre pause, encore moins l\'ultime défaite qu\'est la mort. C\'est vous qui pouvez mettre fin à son combat maintenant. Je crois que s\'excuser ferait cela.%SPEECH_OFF%Barnabas s\'avance et explique, encore une fois, que Hoggart n\'a travaillé que pour s\'assurer que le domaine reste au sein de la famille. Tout ce qu\'il faisait était pour la famille. Il n\'était pas un homme mauvais ou cruel, il faisait seulement ce qu\'il pensait être juste. %witchhunter% jette une main comme pour dire \'voir\'.%SPEECH_ON%Eh bien, voilà. Capitaine, écoutez. Quelle que soit la querelle qu\'il y avait entre vous deux, c\'est fini. C\'est autre chose. Aucun homme ne mérite ce sort. Présentez-lui vos excuses du fond du cœur et vous pourrez mettre fin à ses souffrances une fois pour toutes.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bien. Rien ne va ici",
					function getResult( _event )
					{
						return "J";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Witchhunter.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "J",
			Text = "[img]gfx/ui/events/event_76.png[/img]Vous vous dirigez vers Hoggart. Il grogne et vous regarde un instant avant de fixer la maison. Avec un autre pas prudent, vous venez vous placer devant lui. Ses yeux vitreux et desséchés vous fixent, mais il ne détourne pas les yeux cette fois. Vous parlez.%SPEECH_ON%Hoggart...%SPEECH_OFF%Le mort-vivant se penche en arrière, ses yeux s\'amincissant d\'incrédulité, sa main touchant sa poitrine. Sa voix semble se déployer, tendue depuis les profondeurs d\'un corps emprunté.%SPEECH_ON%Hoggart... J\'ai... essayé...%SPEECH_OFF%Acquiesçant, vous enfoncez vos pouces dans votre ligne de ceinture.%SPEECH_ON %Je sais que vous avez essayé. Je veux dire, je ne savais pas que tu essayais de commencer, mais maintenant je sais. Écoute, ton frère m\'a tout dit. Si j\'avais su, je n\'aurais pas pris ce contrat. Tu n\'as pas...%SPEECH_OFF%Vous jetez un coup d\'œil à %witchhunter% qui acquiesce. Vous continuez.%SPEECH_ON%Hoggart, tu ne méritais pas de mourir. Pas comme ça. Si j\'étais à ta place, j\'aurais fait la même chose. Mais je n\'étais pas à ta place. Je n\'aurais pas pu comprendre qui tu étais ni ce que tu faisais. Je ne faisais que ce pour quoi j\'étais payé. Je ne peux pas revenir sur ce qui a été fait, tout ce que je peux faire, c\'est dire... je suis désolé. Tu ne méritais pas cette douleur et je suis désolé. %SPEECH_OFF%Les yeux vitreux et tombants de Hoggart vous fixent un moment de plus, puis soudain son corps vacille et tombe en avant. Deux esprits émergent, l\'un se tordant et filant à travers la terre boueuse, agitant les pierres avec des larmes de ses spectres bleus alors qu\'il file droit vers l\'horizon. Mais l\'autre esprit reste, brillant d\'un or pâle maintenant, et il flotte simplement vers la maison. Barnabas le suit et vous après lui. Ensemble, vous tournez un coin et vous dirigez vers l\'arrière de la propriété où le fantôme de Hoggart s\'arrête.%SPEECH_ON%Tout ce que j\'ai fait, pour ça. Ne m\'appartient plus. Bien à vous.%SPEECH_OFF%L\'esprit s\'estompe alors que Barnabas tend la main vers lui, une poussière scintillante flottant loin de son toucher. Vous remarquez que la terre a été retournée ici et qu\'une caisse s\'enfonce dans l\'eau de pluie. En le faisant glisser et en l\'ouvrant, vous trouvez une énorme épée avec des décorations du nom de famille de Hoggart. Baranabas a l\'air aussi choqué que vous.%SPEECH_ON%L\'héritage familial. Il a dit qu\'il ne le vendrait jamais pour sauver le domaine, il pensait que l\'un ne pouvait pas aller sans l\'autre. Quand je lui ai dit qu\'il fallait le faire, il l\'a emmené en ville, puis est revenu et m\'a dit qu\'il l\'avait perdu au jeu... Je ne lui ai plus jamais parlé. La dernière chose que je lui ai dite, c\'est qu\'il n\'était qu\'un mauvais vagabond et le pire frère que l\'on puisse avoir. Maintenant je connais la vérité. Tu m\'as apporté, à moi et à mon frère, la paix, merde, et cette paix est tout ce dont je veux me souvenir. S\'il vous plaît, comme mon frère l\'a dit, prenez l\'héritage.%SPEECH_OFF%Vous prenez l\'épée et souhaitez le meilleur à Barnabas. La dernière fois que vous le voyez, il est assis dans la boue, le corps voûté, titubant et pleurant avec la pluie tout autour de lui jusqu\'à ce qu\'il n\'y ait plus d\'homme du tout, juste une maison chaleureuse et une tempête grondant d\'éclairs dorés.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Repose en paix Hoggart.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(1);
				this.Characters.push(_event.m.Witchhunter.getImagePath());
				local item = this.new("scripts/items/weapons/named/named_greatsword");
				item.m.Name = "Hoggart\'s Heirloom";
				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous obtenez " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isUndeadScourge())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		if (!this.World.Flags.get("IsHoggartDead") == true)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_witchhunter = [];
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.witchhunter")
			{
				candidates_witchhunter.push(bro);
			}
			else
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		if (candidates_witchhunter.len() != 0)
		{
			this.m.Witchhunter = candidates_witchhunter[this.Math.rand(0, candidates_witchhunter.len() - 1)];
		}

		this.m.Other = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"chosenbrother",
			this.m.Other.getName()
		]);
		_vars.push([
			"witchhunter",
			this.m.Witchhunter != null ? this.m.Witchhunter.getName() : ""
		]);
		_vars.push([
			"reward",
			"300"
		]);
	}

	function onClear()
	{
		this.m.Witchhunter = null;
		this.m.Other = null;
	}

});

