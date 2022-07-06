this.traveler_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.traveler";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Vous regardez au loin un voyageur qui s\'avance, avachi et chantonnant comme une gargouille sans ailes. Sa canne bouge devant lui et même au loin, on entend le ricanement et le bruit des pierres que l\'on tape. Vous donnez l\'ordre à vos hommes d\'attendre, laissant l\'étranger venir à vous.\n\nQuand il s\'approche enfin, il lève les yeux. Au début, on ne voit que son nez, le reste du corps étant caché sous un manteau. Il renifle avec précaution comme une taupe aveugle tombée dans une endroit étrange. Au moment où vous commencez à lui demander s\'il va bien, il jette son manteau et se dévoile. Ce qui vous fait face est une silhouette fatiguée. Entravé. Les jours sans sommeil creusent les plis de ses yeux. Les joues rougies s\'écartent quand il sourit. Il demande s\'il peut rester avec votre groupe pour un temps. | Un voyageur hèle votre groupe depuis le bord de la route. Il dit qu\'il est en route pour %randomtown% mais qu\'il ne serait pas contre une pause. Sa prochaine question est évidente: il se demande s\'il serait possible de passer la nuit avec votre groupe. | Un voyageur poussant un chariot de biens personnels se dirige vers vous. Vous le laissez approcher, en levant la main pour l\'avertir de ne pas aller plus loin. Il déclare qu\'il est un simple vagabond et qu\'il cherche seulement à se rendre à %randomtown%. Montrant d\'abord qu\'il n\'est absolument pas armé, il demande s\'il peut passer la nuit en votre compagnie. | Un homme en train de siffler se promène sur la route, un chien joyeux haletant à ses côtés, la langue pendante. Voyant votre troupe, il plante son bâton de marche dans la terre et pose ses mains dessus. Il parle un peu du temps, notamment du fait que les nuages sont chargés et qu\'il va sûrement pleuvoir. Il demande si peut-être il pourrait éviter la pluie en compagnie des mercenaires. Une demande étrange, qui n\'est pas habituellement faite aux hommes qui gagnent de l\'argent au prix du sang versé. | Un homme marche sur la route avec une pelle sur une épaule et un sac de terre dans l\'autre main. Lorsque vous lui demandez ce qu\'il fait, il répond qu\'il vient d\'enterrer son frère et qu\'il est sur le chemin du retour vers %randomtown%. Le sac contient un peu de terre où son frère a été enterré. Respectable. L\'homme a l\'air fatigué, aussi fatigué que peut l\'être un homme qui a enterré son frère. Sentant peut-être votre regard compatissant, il demande s\'il peut rester en votre compagnie pour un temps. | Vous apercevez un homme étrange qui marche en clopinant le long de la route. Il est vêtu d\'une longue cape et a un sac à dos accroché à l\'une de ses épaules. Ses yeux fixent le sol jusqu\'à ce qu\'ils arrivent à vos pieds et qu\'il lève enfin les yeux. En voyant votre compagnie, l\'homme est étonnamment calme. En fait, il est plutôt réceptif à votre présence et demande s\'il pourrait peut-être passer la nuit avec des mercenaires avant de poursuivre son voyage vers %randomtown%. | Un homme avec une fourche traverse un champ où les cultures ont été perdues. Ses pieds éraflent la terre morte, vous voyez des touffes de cendres lancées au gré du vent. Lorsqu\'il arrive sur la route, vous le héler et lui demandez d\'où il vient. L\'homme est un travailleur journalier qui essaie seulement de rentrer chez lui. Tout le travail par ici s\'est asséché, littéralement. Se léchant les lèvres, l\'homme se demande s\'il ne pourrait pas passer la nuit avec vous. Il a certainement l\'air d\'avoir besoin de repos de toute façon. | Un homme portant un seau rempli d\'outils croise le chemin de votre compagnie. En vous voyant, l\'étranger évalue la situation en posant ses marchandises et en levant les mains. Vous lui dites de se calmer et lui demandez où il va. Il explique qu\'il est un maçon de %randomtown%, mais que son travail là-bas est terminé. Il est seulement sur le chemin du retour vers sa famille située dans une ferme à une bonne journée de marche de là où vous vous trouvez. Ayant l\'air plutôt assoiffé et fatigué, l\'homme demande s\'il pourrait peut-être passer la nuit en votre compagnie afin de se reposer pour la marche à venir. | Une silhouette apparaît à l\'horizon, floue et chatoyante dans une brume de chaleur. Elle semble s\'être arrêtée, vous ayant sans doute vu aussi. Sans grande crainte, vous poussez les hommes à avancer et tombez bientôt sur un homme transportant des bricoles. Il est assis sur le sol et ne prend pas la peine de se lever lorsque vous vous approchez. Il explique qu\'il est sur la route depuis des jours et qu\'il a besoin d\'une bonne nuit de repos. Naturellement, il demande s\'il peut passer ce moment de repos en compagnie de vos hommes. | Vous rencontrez un homme affaibli et fatigué. Il vous explique qu\'il a cherché son chien qui s\'est perdu, mais qu\'il a presque abandonné. Avant de rentrer chez lui, il demande à voix haute si une nuit de repos en votre compagnie ne pourrait pas l\'aider à trouver l\'énergie de chercher son cabot un jour de plus. | Un homme traqué par des buses est retrouvé sur le bord de la route. Il n\'est pas blessé, juste épuisé. Il demande d\'une voix cassante s\'il pourrait passer la nuit en compagnie de vos hommes.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Rejoignez-nous au feu de camp pour ce soir.",
					function getResult( _event )
					{
						this.World.Assets.removeRandomFood(3);
						local n = this.Math.rand(1, 18);

						switch(n)
						{
						case 1:
							return "B1";

						case 2:
							return "C1";

						case 3:
							return "D1";

						case 4:
							return "E1";

						case 5:
							return "F1";

						case 6:
							return "G1";

						case 7:
							return "H1";

						case 8:
							return "I1";

						case 9:
							return "J1";

						case 10:
							return "K1";

						case 11:
							return "L1";

						case 12:
							return "M1";

						case 13:
							return "N1";

						case 14:
							return "O1";

						case 15:
							return "P1";

						case 16:
							return "Q1";

						case 17:
							return "R1";

						case 18:
							return "S1";
						}
					}

				},
				{
					Text = "Non, gardez vos distances.",
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
			ID = "B1",
			Text = "[img]gfx/ui/events/event_26.png[/img] Vous êtes assis autour d\'un feu. On parle beaucoup de choses et d\'autres, mais le voyageur prononce quelques mots qui restent dans votre esprit longtemps après son départ.%SPEECH_ON%L\'homme est voué à la guerre dès sa naissance. C\'est sa mère qui est avec lui pour sa première et sa dernière bataille. Si seulement le mal que nous voyons chez les autres pouvait être aussi perçu en nous-mêmes, alors l\'appel aux armes pourrait tomber dans l\'oreille d\'un sourd. Quelle tristesse que les hommes soient si peu à l\'aise à l\'idée de faire un travail sur eux-mêmes, et quelle tristesse que, lorsque l\'appel aux armes est lancé, nos oreilles entendent mieux que jamais.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "C\'était à moi de répondre, voyageur.",
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
			ID = "C1",
			Text = "[img]gfx/ui/events/event_26.png[/img]Vous êtes assis autour d\'un feu. On parle beaucoup de choses et d\'autres, mais le voyageur prononce quelques mots qui restent dans votre esprit longtemps après son départ.%SPEECH_ON%Il y a quelques mois, je me suis retrouvé au sommet d\'une montagne. Le plus haut que j\'ai jamais atteint! Un homme plus intelligent que moi s\'est dit que ça pourrait être utile de sortir ses grandes lunettes et de les pointer vers le ciel. Bref, j\'ai regardé le pays de là où j\'étais et j\'ai pu voir ce qu\'on lui avait fait. Villes, villages et routes, petites taupinières de mosaïque granuleuse. Des chariots se déplaçant comme des fourmis, vendant ce qui pouvait être dérobé à cet homme, cet animal ou cette terre. Des trous dans les forêts, là où il y avait des arbres.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "L\'homme a certainement fait forte impression.",
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
			ID = "D1",
			Text = "[img]gfx/ui/events/event_26.png[/img]Vous êtes assis autour d\'un feu. On parle beaucoup de choses et d\'autres, mais le voyageur prononce quelques mots qui restent dans votre esprit longtemps après son départ.%SPEECH_ON%Merci de m\'offrir du poisson, messieurs, mais je vais devoir le refuser. Laissez-moi vous expliquer. L\'autre jour, un proche est décédé, j\'ai creuser un trou comme n\'importe qui l\'aurait fait. C\'était un cousin éloigné qui habitait pas loin. Il vivait à côté, en fait. Feller est mort de maladie, quelque chose que nous ne connaissions pas, que personne d\'autre que lui n\'a eu, je croyais que tout allait bien. Il était tout vert quand il est mort. Vous savez ce que ça pouvait être?%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Je ne sais pas.",
					function getResult( _event )
					{
						return "D2";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "D2",
			Text = "[img]gfx/ui/events/event_26.png[/img]%SPEECH_ON%Non? Merde. Bref, j\'ai creusé la tombe pour lui, car il n\'allait sûrement pas le faire lui-même. J\'avais déjà bien creusé quand je suis tombé sur une grosse pierre. La pioche l\'a frappée, le manche s\'est cassé en deux et la pioche a été réduite en poussière. J\'ai dit: \"Merde, je suis allé trop loin pour m\'arrêter ici, alors dégage, saloperie de pierre!\". Mais cette pierre avait des os à l\'intérieur. Pas dessus, dedans. Des os étranges, mais des os quand même. D\'un point de vue extérieur, la mort est étonnement familière.\n\nQuoi qu\'il en soit, le crâne semblait me regarder, me juger, me dire: \"Qu\'est-ce que tu crois faire ici ?\" Alors je suis sorti de ce trou et j\'ai couru jusqu\'à chez moi, les restes de mon cousin accrochés à mes épaules comme si je les avais volés. J\'étais perturbé. Je n\'arrivais pas à dormir. J\'avais l\'impression d\'être allongé sur ce qui devait être des centaines de gars à cet instant, certains si vieux qu\'ils ressemblaient à des pierres naturelles. Des hommes morts. Tout le long du chemin. Rien que des morts! Je ne savais pas quoi faire et ca me perturbe encore aujourd\'hui. Même si c\'est pas évident.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Un peu, oui.",
					function getResult( _event )
					{
						return "D3";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "D3",
			Text = "[img]gfx/ui/events/event_26.png[/img]%SPEECH_ON%Plus tard, j\'ai décidé que je ne voulais plus enterrer mon cousin. Au lieu de cela, j\'ai brûlé ses restes et jeté le tas de ce qui restait, mijotant et fumant, dans un étang. Je me suis dit, \"cousin, tu ne seras pas un rocher\".\n\nMais l\'autre jour, j\'ai trouvé ces os qui ont été rejetés sur le rivage, il y avait un gros poisson ventru pris dans les côtes. Il s\'est enfermé là parce qu\'il mangeait bien, je suppose. J\'ai ramassé ce poisson et l\'ai tenu, ainsi donc que mon cousin, dans ma main. Il était mou. Un poisson aux yeux exorbités. Mais un chien est passé par là et me l\'a pris. Il l\'a gobé rapidement car il connaissait la nature de son crime, je pense. C\'est là qu\'une partie de mon cousin s\'est enfui. Il a esquivé le fait d\'être un rocher pour finir dans le ventre d\'un poisson puis, au final, être déféquer par un chien. Alors maintenant vous savez pourquoi je ne mange plus de poisson.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Huh. Une histoire intéressante.",
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
			ID = "E1",
			Text = "[img]gfx/ui/events/event_26.png[/img] Vous êtes assis autour d\'un feu. On parle beaucoup de choses et d\'autres, mais le voyageur prononce quelques mots qui restent dans votre esprit longtemps après son départ.%SPEECH_ON%J\'ai pris part aux campagnes de l\'Est. Je conduisais les wagons de ravitaillement, transportant un nombre incalculable d\'armures, d\'armes, de chevaux, de nourriture, etc. Bon sang, cela fait plus de dix ans, je crois. C\'est la dernière fois que les hommes se sont vraiment unis, et je suppose que c\'est la dernière fois que les peaux vertes ont fait de même. Ce n\'est pas un mystère que lorsque les deux forces se sont rencontrées, elles se sont déchirées l\'une contre l\'autre. Maintenant, nous vivons un temps de chaos, de rumeurs, de superstitions et de discussions futiles entre étrangers.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Puissiez-vous trouver la paix sur les routes, voyageur.",
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
			ID = "F1",
			Text = "[img]gfx/ui/events/event_26.png[/img] Vous êtes assis autour d\'un feu. On parle beaucoup de choses et d\'autres, mais le voyageur prononce quelques mots qui restent dans votre esprit longtemps après son départ.%SPEECH_ON%Il y a dix ans, j\'ai participé à la Bataille aux Multiples Noms. L\'orque contre l\'homme. La fin d\'une guerre qui a frappé de son nom toute une époque. J\'ai chevauché avec la cavalerie, si vous voulez savoir. C\'était au niveau du flanc sud; rempli de boues et de marécages. Aucun de nous n\'était adapté à l\'équitation mais notre commandant ne voulait rien savoir. Un orque a transpercé le cheval de ce commandant avec une arme de poing, puis le commandant lui-même. Emmener des chevaux dans cette boue... une mauvaise idée. J\'ai entendu que le flanc nord s\'en sortait mieux, mais ça n\'a pas d\'importance. Aucun des deux camps n\'a gagné cette satanée bataille.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Puissiez-vous trouver la paix sur les routes, voyageur.",
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
			ID = "G1",
			Text = "[img]gfx/ui/events/event_26.png[/img] Vous êtes assis autour d\'un feu. On parle beaucoup de choses et d\'autres, mais le voyageur prononce quelques mots qui restent dans votre esprit longtemps après son départ.%SPEECH_ON%Vous avez déjà vu une peau verte découper la tête d\'un cheval? C\'est un sacré spectacle. Mais j\'ai aussi vu un cheval arracher les dents d\'un orque et l\'enterrer dans la boue en le piétinant comme un fou. Nous oublions, je pense, que le cheval est plus à même de fantasmer une guerre que nous. Des animaux affreux et curieux, certes, mais violents. On dit que, livrés à eux-mêmes, ils s\'entretueraient, tueraient les enfants des autres et les enfants de leurs enfants. C\'est une putain de chose que les femmes nous aiment tous les deux.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Puissiez-vous trouver la paix sur les routes, voyageur.",
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
			ID = "H1",
			Text = "[img]gfx/ui/events/event_26.png[/img] Vous êtes assis autour d\'un feu. On parle beaucoup de choses et d\'autres, mais le voyageur prononce quelques mots qui restent dans votre esprit longtemps après son départ.%SPEECH_ON%Ah, la Bataille aux Multiples Noms. Oui, j\'y ai pris part. L\'avant-garde. Devant et au centre. Non, je ne souhaite pas en parler.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Puissiez-vous trouver la paix sur les routes, voyageur.",
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
			ID = "I1",
			Text = "[img]gfx/ui/events/event_26.png[/img] Vous êtes assis autour d\'un feu. On parle beaucoup de choses et d\'autres, mais le voyageur prononce quelques mots qui restent dans votre esprit longtemps après son départ.%SPEECH_ON%La Bataille aux Multiples Noms? Qui n\'y a pas participé? La moitié du monde était alors en marche, je le jure. Je me tenais avec l\'infanterie. Le valet de pied d\'un seigneur, pour être précis. Je l\'ai bien protégé jusqu\'à ce que les orques libèrent leurs berserkers. Après ça, tout le monde a cherché à se protéger, une tâche qui s\'est avérée assez difficile. J\'avais l\'habitude de mentir sur la façon dont je m\'en suis sorti. Maintenant, je ne le fais plus. La vérité est que mon seigneur a eu le visage écrasé par une chaîne, sa monture a basculé et est tombée sur moi, son pauvre cœur frappé de terreur.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Que s\'est-il passé ensuite?",
					function getResult( _event )
					{
						return "I2";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "I2",
			Text = "[img]gfx/ui/events/event_26.png[/img] Le voyageur s\'arrête, le regard fixé sur le feu de camp. Il le touche avec un bâton.%SPEECH_ON%C\'est la dernière chose dont je me souvienne en ce qui concerne le combat. J\'ai fini par me réveiller avec la pluie qui me tombait dessus. J\'ai failli me noyer dans mon sommeil. J\'ai réussi à m\'extirper du cheval et ramper jusqu\'à Dieu sait où. Des orcs et des hommes gisaient partout, morts, mourants, noyés. Beaucoup de cris. Je ne pouvais pas dire de qui ou de quoi ils provenaient. Je me souviens de la boue. Je me souviens qu\'elle s\'est accrochée à moi. Une jeune fille, forte comme un boeuf, m\'a sauvé. Elle m\'a jeté sur un chariot, la dernière chose que j\'ai vue, c\'est le champ de bataille et, je suis désolé mais je dois m\'arrêter. Merci de m\'avoir accueilli pour la nuit.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Puissiez-vous trouver la paix sur les routes, voyageur.",
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
			ID = "J1",
			Text = "[img]gfx/ui/events/event_26.png[/img] Vous êtes assis autour d\'un feu. On parle beaucoup de choses et d\'autres, mais le voyageur prononce quelques mots qui restent dans votre esprit longtemps après son départ.%SPEECH_ON%J\'ai dirigé une compagnie au sein de la Bataille aux Multiples Noms. C\'était une affaire de justice. Homme contre orc! Oh, quel spectacle. La moitié de mes hommes sont morts sur ces champs, mais leur sacrifice a sauvé tout le pays! Je repense avec tendresse à cette époque. Quel homme ne le ferait pas?%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Un noble récit, étranger.",
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
			ID = "K1",
			Text = "[img]gfx/ui/events/event_26.png[/img] Vous êtes assis autour d\'un feu. On parle beaucoup de choses et d\'autres, mais le voyageur prononce quelques mots qui restent dans votre esprit longtemps après son départ.%SPEECH_ON%Dans la ville de %randomtown%, il y avait un père qui passait en jugement. Il avait tué deux frères parce qu\'ils avaient renversé son chariot. Apparemment, il a pris goût aux meurtres. Au total, il a pris la vie d\'au moins sept personnes. Évidemment, ils ont pendu l\'homme. Mais j\'ai rencontré son fils l\'autre jour et il m\'a dit que la pendaison était simplement dû à une erreur administrative. Son père était un homme droit, pas du tout intéressé et les gens qu\'il a tués l\'ont bien mérité. Ce qui est encore plus curieux, c\'est que ce jeune homme est maintenant maire! Si je me souviens bien, le père a massacré sept personnes. Juste comme ça! Mais la dernière fois que j\'étais en ville, ils avaient déplacé sa dépouille dans un cimetière convenable et je serai damné si je ne voyais pas les fleurs sur la pierre tombale. Je ne sais pas trop quoi en penser.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Les gens essaient de voir le meilleur en eux-mêmes.",
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
			ID = "L1",
			Text = "[img]gfx/ui/events/event_26.png[/img] Vous êtes assis autour d\'un feu. On parle beaucoup de choses et d\'autres, mais le voyageur prononce quelques mots qui restent dans votre esprit longtemps après son départ.%SPEECH_ON%Vous n\'êtes pas la seule compagnie de mercenaires par ici. Je suis sûr que vous le savez. Je ne veux pas paraître menaçant, mais je veux juste vous dire quelque chose. Il y a quelques semaines, deux ou trois compagnies d\'hommes, comme la vôtre, se sont rencontrées à un carrefour et apparemment le chemin n\'était pas assez large pour tout le monde, alors ils se sont battus. Si certains ont survécu, ce n\'était pas le cas de tout le monde. J\'aime vos hommes. Ce sont des gens bien. Mais s\'il vous plaît, soyez prudents là-bas. Tuer des pillards, des brigands et je ne sais quoi d\'autre n\'est pas la seule chose que vous ferez. Vous appartenez à une marché très compétitif, mercenaire.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous garderons un oeil ouvert.",
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
			ID = "M1",
			Text = "[img]gfx/ui/events/event_26.png[/img] Vous êtes assis autour d\'un feu. On parle beaucoup de choses et d\'autres, mais le voyageur prononce quelques mots qui restent dans votre esprit longtemps après son départ.%SPEECH_ON%Un garçon a volé mon déjeuner l\'autre jour, mais il n\'a rien fait d\'autre que de rester là et de le manger devant moi. J\'ai dit: \"Rends-moi mon déjeuner, espèce de salaud\", mais il a refusé. J\'ai essayé de l\'attraper, mais ses jambes maigres ont prouvé qu\'il était plus chat que poulet. J\'ai dit, non, j\'ai demandé pourquoi il avait manger devant moi. C\'était une torture, vous voyez. Il a dit \"parce que j\'ai faim\". Je lui ai dit : \"Moi aussi j\'ai faim, alors rends-le moi\". Naturellement, il a dit non. Et donc, quand il s\'est retourné, je lui ai lancé une pierre, ça a ralenti un peu sa vitesse et j\'ai pu récupéré mon déjeuner. \n\n Mais alors arrive un valet de pied du maire qui dit \"ne fais pas ça\". Je lui ai demandé pourquoi, il a répondu: \"parce que c\'est le garçon du maire\". Ce que j\'avais fait n\'était pas grave, mais on m\'a averti de ne pas recommencer. J\'ai dit au valet: \"dis au garçon de ne plus voler !\". Et ils ont dit qu\'ils l\'avaient fait, et que j\'étais plus susceptible de céder à un ordre que lui. C\'est comme ça que ça s\'est passé. Putain de petites villes, je jure sur mes couilles que ces endroits sont plus "billy" que "hill".%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "La vengeance, la plus douce des épices.",
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
			ID = "N1",
			Text = "[img]gfx/ui/events/event_26.png[/img] Vous êtes assis autour d\'un feu. On parle beaucoup de choses et d\'autres, mais le voyageur prononce quelques mots qui restent dans votre esprit longtemps après son départ.%SPEECH_ON%La mort était étrange pendant la Bataille aux Multiples Noms. Les Orcs tuent beaucoup plus rapidement que les hommes. Ils vous laissent que peu de temps entre le présent et le futur. J\'ai bien vu leur travail après que tout ait été dit et fait. Des hommes éparpillés en morceaux. Des parties entières, des jambes, des bras, des corps séparés par des coupes peu naturelles. Mort instantanée. Swing, la tête est partie! Le corps s\'effondre et se raidit. La plupart des morts ressemblaient à ça, comme s\'ils avaient eu peur et étaient restés figés dans leur malaise. La plupart ne ressemblaient pas du tout à des hommes. Quand il est mort, un homme doit avoir l\'air endormi, vous savez?%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Ouais.",
					function getResult( _event )
					{
						return "N2";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "N2",
			Text = "[img]gfx/ui/events/event_26.png[/img]Il continue.%SPEECH_ON%Quelques-uns ont reçu la grâce d\'une mort lente. Une pause pour se préparer, se mettre à l\'aise, trouver la paix, pour finir par se mettre en boule et quitter cet vie dans un état similaire à celui dans lequel ils étaient arrivés. Mais il y avait un homme, blessé à la ceinture, qui a réussi à survivre. Je l\'ai trouvé moi-même. Je lui ai dit de fermer les yeux parce que je pensais que s\'il s\'endormait, il se réveillerait peut-être. Mais il ne s\'est pas endormi. Il a juste continué à respirer et à parler. Il parlait de ce poulet qu\'il avait quand il était petit, et comment il s\'était énervé quand son père l\'avait abattu. Il a parlé d\'une fille, puis d\'une épouse et d\'une mère. Parlé de deux mères, en fait.%SPEECH_OFF%L\'homme s\'arrête, fixant le feu de camp. Il lève les yeux vers vous.%SPEECH_ON%Je ne savais pas que la moitié d\'un homme pouvait vivre si longtemps.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Puissiez-vous trouver la paix sur les routes, voyageur.",
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
			ID = "O1",
			Text = "[img]gfx/ui/events/event_26.png[/img] Vous êtes assis autour d\'un feu. On parle beaucoup de choses et d\'autres, mais le voyageur prononce quelques mots qui restent dans votre esprit longtemps après son départ.%SPEECH_ON%J\'ai vu un homme fauché par la foudre il y a quelques mois. Son nom était %randomname%. Sa bouche ressemblait à une scierie, une morceau de bois d\'un côté à l\'autre. On pouvait dire qu\'il avait des termites à la place des dents! Quoi qu\'il en soit, sa tête était enflammée, son sourire était figé, sa chair recourbée en bandes noires et violettes. Le sol autour de lui était brûlé, de la fumée flottait et de petits feux crépitaient. Mais il était encore en vie. J\'ai donc couru chercher de l\'aide quand j\'ai entendu un bruit horrible derrière moi. Ce satané éclair l\'avait encore frappé! Frappé par les dieux de part en part.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Qu\'il repose en paix.",
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
			ID = "P1",
			Text = "[img]gfx/ui/events/event_26.png[/img] Vous êtes assis autour d\'un feu. Le voyageur parle d\'une nouvelle futile.%SPEECH_ON%Ils ont pendu une femme à %randomtown%. Je ne l\'ai pas vue tomber, mais je l\'ai vue se balancer. Ils ont dit qu\'elle avait embroché la tête d\'un homme pendant qu\'il dormait. Quelle gueuse.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Intéressant.",
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
			ID = "Q1",
			Text = "[img]gfx/ui/events/event_26.png[/img] Vous êtes assis autour d\'un feu. Le voyageur parle d\'un crime et de son châtiment.%SPEECH_ON%À %randomtown%, ils ont pendu un garçon pour avoir tué un marchand. Ils ont dit qu\'il avait jeté une pierre sur le commerçant pour le faire tomber de son chariot. Il a ensuite couru pour lui voler ses affaires, mais l\'homme lapidé n\'était pas assommé, alors il a sorti sa dague et le garçon a sorti la sienne. Je suppose que le garçon est celui qui est resté debout quand tout était fini. Il en eu juste marre de porte les coups. La rumeur dit qu\'il a frappé fort et longtemps, qu\'il n\'a pas arrêté de frapper même après la mort du marchand. Peut-être que ses pieds froids cherchaient de la chaleur.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Intéressant.",
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
			ID = "R1",
			Text = "[img]gfx/ui/events/event_26.png[/img] Vous êtes assis autour d\'un feu. On parle beaucoup de choses et d\'autres,  mais le voyageur devient un peu nerveux et vous lui demandez ce qui se passe.%SPEECH_ON%J\'ai entendu des rumeurs concernant des cimetières qui étaient vides. Ils ont pendu un homme à %randomtown% pour avoir profaner des tombes. Malheureusement ils continuaient à trouver des tombes vides de toute façon. Je ne suis pas superstitieux, mais d\'après ce que j\'ai entendu, les morts sortent de terre.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Ce ne sont que des ouï-dire. Vous n\'avez rien à craindre.",
					function getResult( _event )
					{
						return "R2";
					}

				},
				{
					Text = "Ce que vous avez entendu est vrai.",
					function getResult( _event )
					{
						return "R3";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "R2",
			Text = "[img]gfx/ui/events/event_26.png[/img] %SPEECH_ON%Ouf. Ouais, je suppose que vous avez raison. Un mort qui se remet à marcher? Ha! Je laisse ces histoires aux enfants.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Effectivement.",
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
			ID = "R3",
			Text = "[img]gfx/ui/events/event_26.png[/img] %SPEECH_ON%Que les anciens dieux aient pitié car si ma maudite belle-mère revient sur terre, elle n\'aura certainement rien pour moi.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Une perspective effrayante.",
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
			ID = "S1",
			Text = "[img]gfx/ui/events/event_26.png[/img] Vous êtes assis autour d\'un feu. L\'homme à l\'air plutôt malheureux regarde fixement le feu en parlant.%SPEECH_ON%J\'ai entendu dire que les riches ont ces trucs qui leur permettent de voir à quoi ils ressemblent. Des miroirs! Oui, c\'est ça. J\'aimerais en avoir un. Je n\'ai pas vu mon propre visage depuis... eh bien, depuis toujours. C\'est peut-être un peu comme quand on regarde fixement dans un étang, je suppose.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Il y a des choses qu\'il vaut mieux ne pas voir.",
					function getResult( _event )
					{
						return "S2";
					}

				},
				{
					Text = "On a un miroir juste ici.",
					function getResult( _event )
					{
						return "S3";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "S2",
			Text = "[img]gfx/ui/events/event_26.png[/img] Les sourcils de l\'homme se fronce.%SPEECH_ON%Ah ouais, merci mercenaire, ça me fait me sentir beaucoup mieux. Sale con.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "De rien.",
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
			ID = "S3",
			Text = "[img]gfx/ui/events/event_26.png[/img] L\'homme regarde fixement dans le miroir comme s\'il assistait à sa propre mort. Il se frotte le menton et tourne la tête, cherchant désespérément un angle qui ne le décevra pas.%SPEECH_ON%Que je sois damné si ma mère n\'est pas la plus grande menteuse qui ait jamais marché sur la terre. Regardez-moi cette sale tronche!%SPEECH_OFF%Il rend le miroir et ne peut s\'empêcher de rire de son malheureux visage. %SPEECH_ON%Je suppose que je n\'ai plus à me demander pourquoi les femmes me fuient.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "De rien.",
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
	}

	function onUpdateScore()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Wildmen && currentTile.SquareCoords.Y > this.World.getMapSize().Y * 0.7)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y < this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

